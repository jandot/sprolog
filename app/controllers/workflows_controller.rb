class WorkflowsController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions, :only => [:edit, :destroy]
  # GET /workflows
  # GET /workflows.xml
  def index
    @workflows = Workflow.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @workflows }
    end
  end

  # GET /workflows/1
  # GET /workflows/1.xml
  def show
    @workflow = Workflow.find(params[:id])
    
    default_graph_settings = "node [shape=box,style=filled];\n"
    
    @processed_graph = default_graph_settings + @workflow.graph + process_graph(@workflow)
    
    gv = IO.popen("/usr/local/bin/dot -q -Tpng", "w+")
    gv.puts "digraph G{", @processed_graph, "}"
    gv.close_write
    @gvpng = gv.read


    gv = IO.popen("/usr/local/bin/dot -q -Tcmapx", "w+")
    gv.puts "digraph G{", @processed_graph, "}"
    gv.close_write
    @gvmap = gv.read

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @workflow }
    end
  end

  # GET /workflows/new
  # GET /workflows/new.xml
  def new
    @workflow = Workflow.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @workflow }
    end
  end

  # GET /workflows/1/edit
  def edit
    @workflow = Workflow.find(params[:id])
  end

  # POST /workflows
  # POST /workflows.xml
  def create
    params[:workflow]['project_id'] = session[:project]
    @workflow = Workflow.new(params[:workflow])

    respond_to do |format|
      if @workflow.save
        flash[:notice] = 'Workflow was successfully created.'
        format.html { redirect_to(@workflow) }
        format.xml  { render :xml => @workflow, :status => :created, :location => @workflow }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @workflow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /workflows/1
  # PUT /workflows/1.xml
  def update
    @workflow = Workflow.find(params[:id])

    respond_to do |format|
      if @workflow.update_attributes(params[:workflow])
        flash[:notice] = 'Workflow was successfully updated.'
        format.html { redirect_to(@workflow) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @workflow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /workflows/1
  # DELETE /workflows/1.xml
  def destroy
    @workflow = Workflow.find(params[:id])
    @workflow.destroy

    respond_to do |format|
      format.html { redirect_to(workflows_url) }
      format.xml  { head :ok }
    end
  end
  
  def process_graph(workflow)
    url_string = ""
    workflow.graph.scan(/"(\d+)\.\s(.+?)"/).uniq.each do |task_number, task_description|
      task_id  = Task.id_from_number(task_number.to_i, workflow.project.id)
      if task_id.nil?
        url_string += "\"#{task_number}. #{task_description}\"\n"
      else
        task = Task.find(task_id)
        url_string += "\"#{task_number}. #{task_description}\"[URL=\""
        url_string += "/tasks/#{task_id}\""
        url_string += ", color=red" if task.status == "stalled" # change colour if task stalled
        url_string += ", color=orange" if task.status == "open" # change colour if task open
        url_string += ", color=green" if task.status == "closed" # change colour if task closed
        url_string += "];\n"
      end
    end
    return url_string
  end
  def check_permissions
    workflow = Workflow.find(params[:id])
    project = workflow.project
    if !logged_in? || current_user != project.user
      flash[:error] = "You do not have permission to edit this workflow!"
      redirect_to workflow_path(workflow)
    end
  end
end

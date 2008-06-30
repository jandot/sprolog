class WorkflowsController < ApplicationController
#  before_filter :login_required

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
    
    gv = IO.popen("/usr/local/bin/dot -q -Tsvg", "w+")
    gv.puts "digraph G{", @workflow.graph, "}"
    gv.close_write
    @gvsvg = gv.read

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
end

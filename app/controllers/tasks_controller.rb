class TasksController < ApplicationController
  before_filter :login_required
  before_filter :check_permissions, :only => [:new, :edit, :destroy]
  # GET /tasks
  # GET /tasks.xml
  def index
    session[:task] = nil
    
    if params[:project_id]
      session[:project] = Project.find(params[:project_id]).id
      if params[:status_open]
        @tasks = Task.find_all_by_project_id_and_status(params[:project_id], 'open')
      else
        @tasks = Task.find_all_by_project_id(params[:project_id])
      end
    else
      @tasks = Task.find(:all)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])
    session[:task] = @task.id

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
      format.pdf { send_data render_to_pdf({ :action => 'show.pdf.erb', :layout => nil }) }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    params[:task]['project_id'] = session[:project]
    params[:task]['status'] = 'open'
    params[:task]['created_at'] = Time.now
    params[:task]['updated_at'] = Time.now
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        flash[:notice] = 'Task was successfully created.'
        format.html { redirect_to(@task) }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    params[:task]['project_id'] = session[:project]
    params[:task]['updated_at'] = Time.now
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        flash[:notice] = 'Task was successfully updated.'
        format.html { redirect_to(@task) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    project = @task.project
    @task.destroy
    session[:task ] = nil

    respond_to do |format|
      format.html { redirect_to(project_url(project)) }
      format.xml  { head :ok }
    end
  end

  def open_status
    change_status('open', 'Task reopened at')
  end

  def stall_status
    change_status('stalled', 'Task stalled at')
  end
  
  def close_status
    change_status('closed', 'Task closed at')
  end
  def change_status(status, new_task_description)
    @task = Task.find(params[:id])
    @task.status = status
    @task.steps.create(:description => new_task_description + ' ' + Time.now.to_s)
    @task.updated_at = Time.now
    @task.save
    redirect_to :action => :show
  end
  def check_permissions
    if params[:id]
      task = Task.find(params[:id])
      project = task.project
    else
      project = Project.find(session[:project])
    end
    if !logged_in? || current_user != project.user
      flash[:error] = "You do not have permission to edit or create tasks in this project!"
      redirect_to task_path(task)
    end
  end
end

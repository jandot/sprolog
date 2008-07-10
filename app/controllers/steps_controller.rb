class StepsController < ApplicationController
  before_filter :login_required
  before_filter :ownership_required, :except => [:index, :show]
  
  # GET /steps
  # GET /steps.xml
  def index
    @steps = Step.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @steps }
    end
  end

  # GET /steps/1
  # GET /steps/1.xml
  def show
    @step = Step.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/new
  # GET /steps/new.xml
  def new
    @step = Step.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/1/edit
  def edit
    @step = Step.find(params[:id])
  end

  # POST /steps
  # POST /steps.xml
  def create
    params[:step]['task_id'] = session[:task]
    params[:step]['created_at'] = Time.now
    params[:step]['updated_at'] = Time.now
    @step = Step.new(params[:step])

    respond_to do |format|
      if @step.save
        flash[:notice] = 'Step was successfully created.'
        format.html { redirect_to :controller => :tasks, :action => :show, :id => session[:task] }
        format.xml  { render :xml => @step, :status => :created, :location => @step }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /steps/1
  # PUT /steps/1.xml
  def update
    params[:step]['task_id'] = session[:task]
    params[:step]['updated_at'] = Time.now
    @step = Step.find(params[:id])

    respond_to do |format|
      if @step.update_attributes(params[:step])
        flash[:notice] = 'Step was successfully updated.'
        format.html { redirect_to :controller => :tasks, :action => :show, :id => session[:task] }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.xml
  def destroy
    @step = Step.find(params[:id])
    @step.destroy

    respond_to do |format|
      format.html { redirect_to(steps_url) }
      format.xml  { head :ok }
    end
  end
end

class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @projects = current_user.my_projects
    respond_to do |format|
      format.json { render json: @projects }
    end
  end
  
  def my    
      @projects = current_user.my_projects
      session[:current_tab] = 1
      
      respond_to do |format|
        format.html {render "main/_page"}
        format.json {render json:@projects}
      end
  end
  
  def foreign
    @projects = current_user.shared_projects
    session[:current_tab] = 2
    @foreign = true
      
    respond_to do |format|
      format.html {render "main/_page"}
      format.json {render json:@projects}
    end
  end  
  
  def create
  	@project = Project.new(params[:project])
  	respond_to do |format|
      if current_user.projects << @project && current_user.shares.last.update_attributes(:author=>true)
        format.html { redirect_to root_path, notice: 'Project was successfully created.'}
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { redirect_to root_path}
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
  	end	
  end

  def destroy
   p = Project.find_by_id(params[:id])
   p.destroy
   
   respond_to do |format|
     format.html { redirect_to root_path }
     format.json { head :ok }
   end   
  end

  def update
  	p = Project.find_by_id(params[:id])
  	
  	respond_to do |format|
  	  if p.update_attributes(params[:project])
  	    format.html { redirect_to :back}
        format.json { head :no_content }
      else
        format.html { redirect_to :back}
        format.json { render json: p.errors, status: :unprocessable_entity }
  	  end
  	end  	
  end
  
  def show
  	@projects = session[:current_tab] == 1 ? current_user.my_projects : current_user.shared_projects
   	@project = Project.find_by_id(params[:id])
  	@lists = @project.lists
  	respond_to do |format|
  	  format.html { render "main/_page" }
  	  format.json { render json:@lists }
  	end
  	
  end

  def share
	  if params[:tasks]
      @users = User.where("email = ? and email <> ?",params[:tasks][:email], current_user.email)
    end 
    @shared =  Project.find_by_id(params[:id])
	  @path = share_project_path
	  
	  respond_to do |format|
	    format.html { render "main/_share" }
	    format.json { render:@users }
	  end	  
  end

  def addUser
  	u = User.find_by_id(params[:finded])
  	if u
  		p = Project.find_by_id(params[:id])
  		p.users << u
  		p.shares.where("user_id = ?",u.id).first.update_attributes(:author=>false)
  		#ShareMailer.shareProject(u,p,current_user).deliver
  	end
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end 
  	
  end
  
  def delUser
   	u = User.find_by_id(params[:finded])
	  p = Project.find_by_id(params[:id])
  	if u && u != p.author
  		p.users.destroy u
  	end
    
    respond_to do |format|
      format.html { redirect_to :back } 
      format.json { head :no_content }
    end  	
  end
end

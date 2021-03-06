class ShareMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def shareProject(user, project, current_user)
    @project = project
    @user = current_user
    mail(:to=>user.email, :subject=>"You were added to project")
  end
  
  def shareTask(user, task, current_user)
    @task = task
    @user = current_user
    mail(:to=>user.email, :subject=>"You were added to task")
  end
  
  def changedTaskStatus(task, user, current_user)
    @task = task
    @user = current_user
    @status = task.state ? "complete" : "incomplete"
    mail(:to=>user.email, :subject=>"Task status has changed")
  end
  
end

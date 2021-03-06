class TodoList.Routers.ProjectsRouter extends Backbone.Router
  initialize: (options) ->
    @projects = new TodoList.Collections.ProjectsCollection()
    @projects.reset options.projects
    @lists = new TodoList.Collections.ListsCollection()
    @tasks = new TodoList.Collections.TasksCollection()
    
  routes:
    "/projects/new"      : "newProject"
    "/projects/index"    : "indexProject"
    "/projects/:id/edit" : "editProject"
    "/projects/:id"      : "showProject"
    "/lists/new"      : "newList"
    "/lists/index"    : "indexList"
    "/lists/:id/edit" : "editList"
    "/lists/:id"      : "showList"
    "/tasks/new"  : "newTask"
    "/tasks/index" : "indexTask"
    "/tasks/:id/edit" : "editTask"
    "/tasks/:id"  : "showTask"
    "/tasks/:id/check"  : "checkTask"
    ".*"        : "indexProject"

  newProject: ->
    @view = new TodoList.Views.Projects.NewView(collection: @projects)
    $("#add-project").hide()
    $("#add-project").html(@view.render().el)
    $("#add-project").show(500)

  indexProject: ->
    @view = new TodoList.Views.Projects.IndexView(projects: @projects)
    $("#projects").html(@view.render().el)
    if(@projects.length == 0)
      $("#projects-table").html("<p class=alt style='font-size:14px;'>You don't have any projects!</p>")

  showProject: (id) ->
    project = @projects.get(id)
    @lists.url = '/projects/' + id
    @lists.fetch({add: true})    
    @lists.url = '/projects/' + id + '/lists'
    @lists.project_id = id
    @view = new TodoList.Views.Lists.IndexView(lists: @lists)
    $("#tasksList").html(@view.render().el)
    
  editProject: (id) ->
    project = @projects.get(id)

    @view = new TodoList.Views.Projects.EditView(model: project)
    $("#project"+id).html(@view.render().el)
    
  newList: ->
    @view = new TodoList.Views.Lists.NewView(collection: @lists)
    $("#add-list").hide()
    $("#add-list").html(@view.render().el)
    $("#add-list").show(500)
    
  indexList: ->
    @view = new TodoList.Views.Lists.IndexView(lists: @lists)
    $("#tasksList").html(@view.render().el)

  showList: (id) ->
    project = @projects.get(id)
    @tasks.url = '/projects/' + @lists.project_id + '/lists/' + id
    @tasks.fetch()
    @tasks.list_id = id
    @tasks.url = '/projects/' + @lists.project_id + '/lists/' + id + '/tasks'
    @view = new TodoList.Views.Tasks.IndexView(tasks: @tasks)
    $("#tasks").html(@view.render().el)

  editList: (id) ->
    list = @lists.get(id)

    @view = new TodoList.Views.Lists.EditView(model: list)
    $("#task-list"+id).html(@view.render().el)  
    
  newTask: ->
    @view = new TodoList.Views.Tasks.NewView(collection: @tasks)
    $("#add-tasks").hide()
    $("#add-tasks").html(@view.render().el)
    $("#add-tasks").show(500)

  indexTask: ->
    @view = new TodoList.Views.Tasks.IndexView(tasks: @tasks)
    $("#tasks").html(@view.render().el)

  showTask: (id) ->
    task = @tasks.get(id)

    @view = new TodoList.Views.Tasks.ShowView(model: task)
    $("#tasks").html(@view.render().el)

  editTask: (id) ->
    task = @tasks.get(id)

    @view = new TodoList.Views.Tasks.EditView(model: task)
    $("#task"+id).html(@view.render().el)
    
  checkTask: (id) ->
    task = @tasks.get(id)
    
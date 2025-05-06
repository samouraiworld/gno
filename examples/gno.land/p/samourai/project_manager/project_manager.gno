package project_manager

import (
	"std"

	"gno.land/p/demo/avl"
)

const (
	DivisionTech = "tech"
	DivisionProd = "prod"
)

const (
	StatusTodo  = "todo"
	StatusDoing = "doing"
	StatusDone  = "done"
)

type Task struct {
	Name        string
	Description string
	Members     *avl.Tree // member addr -> struct{}
	Status      string
}

type Project struct {
	Name        string
	Description string
	Division    string
	Members     *avl.Tree // member addr -> struct{}
	Tasks       *avl.Tree
}

type ProjectManager struct {
	Projects *avl.Tree
}

func New() *ProjectManager {
	return &ProjectManager{
		Projects: avl.NewTree(),
	}
}

func (pm *ProjectManager) AddProject(name string, description string, division string, members []std.Address, tasks []Task) {
	if len(name) < 3 {
		panic("name must be at least 3 characters long")
	}

	if len(description) < 15 {
		panic("description must be at least 15 characters long")
	}

	if division != DivisionTech && division != DivisionProd {
		panic("division must be either tech or prod")
	}

	membersTree := avl.NewTree()
	for _, m := range members {
		membersTree.Set(m.String(), struct{}{})
	}

	// TODO: would be nice to have some validation like ensure the avl tree contains only std.Address
	tasksTree := avl.NewTree()
	for _, t := range tasks {
		tasksTree.Set(t.Name, &t)
	}

	pm.Projects.Set(name, &Project{
		Name:        name,
		Description: description,
		Division:    division,
		Members:     membersTree,
		Tasks:       tasksTree,
	})
}

func (pm *ProjectManager) GetProject(name string) *Project {
	projectRaw, ok := pm.Projects.Get(name)
	if !ok {
		panic("project not found")
	}

	return projectRaw.(*Project)
}

func (pm *ProjectManager) ListProjects() []*Project {
	projects := []*Project{}
	pm.Projects.Iterate("", "", func(key string, value interface{}) bool {
		projects = append(projects, value.(*Project))
		return false
	})
	return projects
}

// TODO: would be nice to have some validation like ensure the avl tree contains only std.Address & recursively check the tasks
func (pm *ProjectManager) EditProject(name string, project *Project) {
	_, ok := pm.Projects.Get(name)
	if !ok {
		panic("project not found")
	}

	pm.Projects.Set(name, project)
}

func (pm *ProjectManager) DeleteProject(name string) {
	_, ok := pm.Projects.Get(name)
	if !ok {
		panic("project not found")
	}
	pm.Projects.Remove(name)
}

func (pm *ProjectManager) AddTask(projectName string, name string, description string, members []std.Address) {
	project, ok := pm.Projects.Get(projectName)
	if !ok {
		panic("project not found")
	}

	_, ok = project.(*Project).Tasks.Get(name)
	if ok {
		panic("task already exists")
	}

	membersTree := avl.NewTree()
	for _, m := range members {
		membersTree.Set(m.String(), struct{}{})
	}

	project.(*Project).Tasks.Set(name, &Task{
		Name:        name,
		Description: description,
		Members:     membersTree,
		Status:      StatusTodo,
	})
}

// TODO: would be nice to have some validation like ensure the avl tree contains only std.Address
func (pm *ProjectManager) EditTask(projectName string, taskName string, task *Task) {
	project, ok := pm.Projects.Get(projectName)
	if !ok {
		panic("project not found")
	}

	_, ok = project.(*Project).Tasks.Get(taskName)
	if !ok {
		panic("task not found")
	}

	project.(*Project).Tasks.Set(taskName, task)
}

func (pm *ProjectManager) DeleteTask(projectName string, taskName string) {
	project, ok := pm.Projects.Get(projectName)
	if !ok {
		panic("project not found")
	}

	_, ok = project.(*Project).Tasks.Get(taskName)
	if !ok {
		panic("task not found")
	}

	project.(*Project).Tasks.Remove(taskName)
}

func (pm *ProjectManager) EditTaskStatus(projectName string, taskName string, status string) {
	if status != StatusTodo && status != StatusDoing && status != StatusDone {
		panic("invalid status")
	}

	project, ok := pm.Projects.Get(projectName)
	if !ok {
		panic("project not found")
	}

	task, ok := project.(*Project).Tasks.Get(taskName)
	if !ok {
		panic("task not found")
	}

	task.(*Task).Status = status
}

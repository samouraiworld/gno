package project_manager

import (
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

// TODO: would be nice to have some validation like ensure the avl tree contains only std.Address
func (pm *ProjectManager) AddProject(project *Project) {
	_, ok := pm.Projects.Get(project.Name)
	if ok {
		panic("project already exists")
	}

	pm.Projects.Set(project.Name, project)
}

func (pm *ProjectManager) GetProject(name string) *Project {
	projectRaw, ok := pm.Projects.Get(name)
	if !ok {
		panic("project not found")
	}

	return projectRaw.(*Project)
}

func (pm *ProjectManager) EditProject(name string, project *Project) {
	_, ok := pm.Projects.Get(name)
	if !ok {
		panic("project not found")
	}

	pm.Projects.Set(name, project)
}

func (pm *ProjectManager) DeleteProject(name string) {
	project, ok := pm.Projects.Get(name)
	if !ok {
		panic("project not found")
	}
	pm.Projects.Remove(name)
}

func (pm *ProjectManager) AddTask(projectName string, task *Task) {
	project, ok := pm.Projects.Get(projectName)
	if !ok {
		panic("project not found")
	}

	_, ok = project.(*Project).Tasks.Get(task.Name)
	if ok {
		panic("task already exists")
	}

	project.(*Project).Tasks.Set(task.Name, task)
}

func (pm *ProjectManager) EditTask(projectName string, taskName string, task *Task) {
	project, ok := pm.Projects.Get(projectName)
	if !ok {
		panic("project not found")
	}

	_, ok := project.(*Project).Tasks.Get(taskName)
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

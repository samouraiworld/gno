package samdao

import (
	"errors"
	"std"
	"strings"
	"time"

	"gno.land/p/demo/blog"
	"gno.land/p/demo/ufmt"
	"gno.land/p/samourai/basedao"
	"gno.land/p/samourai/daokit"
	"gno.land/p/samourai/project_manager"
	"gno.land/r/samourai/payrolls"
)

// CHANGE CEO
const MsgChangeCEOKind = "gno.land/r/samourai/samdao.ChangeCEO"

type MsgChangeCEO struct {
	NewCEO std.Address
}

func (m *MsgChangeCEO) String() string {
	return ufmt.Sprintf("Change CEO to %s", m.NewCEO)
}

func NewChangeCEOHandler(dao *basedao.DAOPrivate) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgChangeCEOKind, func(ipayload interface{}) {
		msg, ok := ipayload.(*MsgChangeCEO)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		targetIsCEO := dao.Members.HasRole(msg.NewCEO.String(), "CEO")
		if targetIsCEO {
			panic("target is already CEO")
		}

		ceo := dao.Members.GetMembersWithRole("CEO")
		if len(ceo) != 1 {
			panic("there must be exactly one CEO")
		}

		dao.Members.RemoveRoleFromMember(ceo[0], "CEO")
		dao.Members.AddRoleToMember(msg.NewCEO.String(), "CEO")
	})
}

func NewChangeCEOMsg(newCEO std.Address) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgChangeCEOKind, &MsgChangeCEO{NewCEO: newCEO})
}

// NEW POST

const MsgCreatePostKind = "gno.land/r/samourai/samdao.CreatePost"

type MsgCreatePost struct {
	Slug    string
	Title   string
	Body    string
	Authors []string
	Tags    []string
	PubDate string
}

func (m *MsgCreatePost) String() string {
	s := ""
	s += ufmt.Sprintf("- New post: **%s**\n\n", m.Title)
	s += ufmt.Sprintf("- Slug: **%s**\n\n", m.Slug)
	s += ufmt.Sprintf("- Authors: %s\n\n", strings.Join(m.Authors, ", "))
	s += ufmt.Sprintf("- Tags: %s\n\n", strings.Join(m.Tags, ", "))
	s += ufmt.Sprintf("- PubDate: %s\n\n", m.PubDate)
	s += ufmt.Sprintf("### Body:\n\n%s\n\n", m.Body)
	return s
}

func NewCreatePostHandler(blogTarget *blog.Blog) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgCreatePostKind, func(ipayload interface{}) {
		msg, ok := ipayload.(*MsgCreatePost)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		err := blogTarget.NewPost(std.CurrentRealm().Address(), msg.Slug, msg.Title, msg.Body, msg.PubDate, msg.Authors, msg.Tags)
		if err != nil {
			panic(err)
		}
	})
}

func NewCreatePostMsg(slug, title, body, pubDate string, authors, tags []string) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgCreatePostKind, &MsgCreatePost{
		Slug:    slug,
		Title:   title,
		Body:    body,
		Authors: authors,
		Tags:    tags,
		PubDate: pubDate,
	})
}

// NEW STAKEHOLDER

const MsgAddStakeholderKind = "gno.land/r/samourai/samdao.AddStakeholder"

type MsgAddStakeholder struct {
	Address std.Address
}

func (m *MsgAddStakeholder) String() string {
	return ufmt.Sprintf("Assign stakeholder role to %s", m.Address)
}

func NewAddStakeholderHandler(dao *basedao.DAOPrivate) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgAddStakeholderKind, func(ipayload interface{}) {
		msg, ok := ipayload.(*MsgAddStakeholder)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		dao.Members.AddRoleToMember(msg.Address.String(), "Stakeholder")
	})
}

func NewAddStakeholderMsg(address std.Address) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgAddStakeholderKind, &MsgAddStakeholder{Address: address})
}

// ELECT PROJECT LEAD

const MsgElectDivisionLeaderKind = "gno.land/r/samourai/samdao.ElectDivisionLeader"

type MsgElectDivisionLeader struct {
	Division string
	Address  std.Address
}

func (m *MsgElectDivisionLeader) String() string {
	return ufmt.Sprintf("Elect division %s leader: %s", m.Division, m.Address)
}

func NewElectDivisionLeaderHandler(dao *basedao.DAOPrivate) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgElectDivisionLeaderKind, func(ipayload interface{}) {
		msg, ok := ipayload.(*MsgElectDivisionLeader)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		division := strings.ToLower(msg.Division)
		division = strings.ToUpper(division[:1]) + division[1:]
		dao.Members.AddRoleToMember(msg.Address.String(), division+" Leader")
	})
}

func NewElectDivisionLeaderMsg(division string, address std.Address) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgElectDivisionLeaderKind, &MsgElectDivisionLeader{Division: division, Address: address})
}

// NEW MEDIA PROJECT

const MsgCreateProdProjectKind = "gno.land/r/samourai/samdao.CreateProdProject"

type MsgCreateProdProject struct {
	Name        string
	Description string
	Members     []std.Address
	Tasks       []project_manager.Task
}

func (m *MsgCreateProdProject) String() string {
	s := ""
	s += ufmt.Sprintf("New prod project: %s\n", m.Name)
	s += ufmt.Sprintf("Description: %s\n", m.Description)
	s += ufmt.Sprintf("Members:\n")
	for _, member := range m.Members {
		s += ufmt.Sprintf("  - %s\n", member.String())
	}
	s += ufmt.Sprintf("Tasks:\n")
	for _, task := range m.Tasks {
		s += ufmt.Sprintf("  - %s\n", task.Name)
		s += ufmt.Sprintf("    - Description: %s\n", task.Description)
		s += ufmt.Sprintf("    - Status: %s\n", task.Status)
	}
	return s
}

func NewCreateProdProjectHandler(pmTarget *project_manager.ProjectManager) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgCreateProdProjectKind, func(ipayload interface{}) {
		msg, ok := ipayload.(*MsgCreateProdProject)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		pmTarget.AddProject(msg.Name, msg.Description, project_manager.DivisionProd, msg.Members, msg.Tasks)
	})
}

func NewCreateProdProjectMsg(name string, description string, tasks []project_manager.Task, members []std.Address) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgCreateProdProjectKind, &MsgCreateProdProject{Name: name, Description: description, Tasks: tasks, Members: members})
}

// NEW TECH PROJECT

const MsgCreateTechProjectKind = "gno.land/r/samourai/samdao.CreateTechProject"

type MsgCreateTechProject struct {
	Name        string
	Description string
	Tasks       []project_manager.Task
	Members     []std.Address
}

func (m *MsgCreateTechProject) String() string {
	s := ""
	s += ufmt.Sprintf("New tech project: %s\n\n", m.Name)
	s += ufmt.Sprintf("Description: %s\n\n", m.Description)
	s += ufmt.Sprintf("Members:\n\n")
	for _, member := range m.Members {
		s += ufmt.Sprintf("  - %s\n\n", member.String())
	}
	s += ufmt.Sprintf("Tasks:\n\n")
	for _, task := range m.Tasks {
		s += ufmt.Sprintf("  - %s\n\n", task.Name)
		s += ufmt.Sprintf("    - Description: %s\n\n", task.Description)
		s += ufmt.Sprintf("    - Status: %s\n\n", task.Status)
	}
	return s
}

func NewCreateTechProjectHandler(pmTarget *project_manager.ProjectManager) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgCreateTechProjectKind, func(ipayload interface{}) {
		msg, ok := ipayload.(*MsgCreateTechProject)
		if !ok {
			panic(errors.New("invalid payload type"))
		}

		pmTarget.AddProject(msg.Name, msg.Description, project_manager.DivisionTech, msg.Members, msg.Tasks)
	})
}

func NewCreateTechProjectMsg(name string, description string, tasks []project_manager.Task, members []std.Address) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgCreateTechProjectKind, &MsgCreateTechProject{Name: name, Description: description, Tasks: tasks, Members: members})
}

// EDIT PAYROLLS

const MsgCreatePayrollKind = "gno.land/r/samourai/samdao.CreatePayroll"

type MsgCreatePayroll struct {
	beneficiary std.Address
	label       string
	distrib     payrolls.DistribFn
	breakup     payrolls.BreakupFn
}

func (m *MsgCreatePayroll) String() string {
	s := ""
	if m.distrib == nil {
		return ufmt.Sprintf("Invalid payrolls: nil distrib\n")
	}
	monthlyCoins := m.distrib(time.Hour * 24 * 30)
	s += ufmt.Sprintf("New payrolls to **%s**\n\n", m.beneficiary)
	s += ufmt.Sprintf("Label: **%s**\n\n", m.label)
	s += ufmt.Sprintf("Distribution per month: **%s**\n\n", monthlyCoins)
	return s
}

func NewCreatePayrollHandler(dao *basedao.DAOPrivate) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgCreatePayrollKind, func(ipayload interface{}) {
		msg, ok := ipayload.(*MsgCreatePayroll)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		namespace := "samdao"
		cross(payrolls.Create)(namespace, msg.label, msg.beneficiary, msg.distrib, msg.breakup)
	})
}

func NewCreatePayrollMsg(beneficiary std.Address, label string, distrib payrolls.DistribFn, breakup payrolls.BreakupFn) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgCreatePayrollKind, &MsgCreatePayroll{beneficiary: beneficiary, label: label, distrib: distrib, breakup: breakup})
}

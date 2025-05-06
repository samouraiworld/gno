package samdao

import (
	"errors"
	"std"
	"strings"

	"gno.land/p/demo/blog"
	"gno.land/p/demo/ufmt"
	"gno.land/p/samourai/basedao"
	"gno.land/p/samourai/daokit"
	"gno.land/p/samourai/project_manager"
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

const MsgNewPostKind = "gno.land/r/samourai/samdao.NewPost"

type MsgNewPost struct {
	Slug    string
	Title   string
	Body    string
	Authors []string
	Tags    []string
	PubDate string
}

func (m *MsgNewPost) String() string {
	return ufmt.Sprintf("New post: %s", m.Title)
}

func NewNewPostHandler(blogTarget *blog.Blog) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgNewPostKind, func(ipayload interface{}) {
		msg, ok := ipayload.(*MsgNewPost)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		blogTarget.NewPost(std.CurrentRealm().Address(), msg.Slug, msg.Title, msg.Body, msg.PubDate, msg.Authors, msg.Tags)
	})
}

func NewNewPostMsg(slug, title, body, pubDate string, authors, tags []string) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgNewPostKind, &MsgNewPost{
		Slug:    slug,
		Title:   title,
		Body:    body,
		Authors: authors,
		Tags:    tags,
		PubDate: pubDate,
	})
}

// NEW STAKEHOLDER

const MsgNewStakeholderKind = "gno.land/r/samourai/samdao.NewStakeholder"

type MsgNewStakeholder struct {
	Address std.Address
}

func (m *MsgNewStakeholder) String() string {
	return ufmt.Sprintf("New stakeholder: %s", m.Address)
}

func NewNewStakeholderHandler(dao *basedao.DAOPrivate) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgNewStakeholderKind, func(ipayload interface{}) {
		msg, ok := ipayload.(*MsgNewStakeholder)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		dao.Members.AddRoleToMember(msg.Address.String(), "Stakeholder")
	})
}

func NewNewStakeholderMsg(address std.Address) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgNewStakeholderKind, &MsgNewStakeholder{Address: address})
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

const MsgNewProdProjectKind = "gno.land/r/samourai/samdao.NewProdProject"

type MsgNewProdProject struct {
	Title       string
	Description string
	Members     []std.Address
	Tasks       []project_manager.Task
}

func (m *MsgNewProdProject) String() string {
	return ufmt.Sprintf("New prod project: %s", m.Title)
}

func NewNewProdProjectHandler(pmTarget *project_manager.ProjectManager) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgNewProdProjectKind, func(ipayload interface{}) {
		msg, ok := ipayload.(*MsgNewProdProject)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		pmTarget.AddProject(msg.Title, msg.Description, project_manager.DivisionProd, msg.Members, msg.Tasks)
	})
}

func NewNewProdProjectMsg(title string) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgNewProdProjectKind, &MsgNewProdProject{Title: title})
}

// NEW TECH PROJECT

const MsgNewTechProjectKind = "gno.land/r/samourai/samdao.NewTechProject"

type MsgNewTechProject struct {
	Title       string
	Description string
	Tasks       []project_manager.Task
	Members     []std.Address
}

func (m *MsgNewTechProject) String() string {
	return ufmt.Sprintf("New tech project: %s", m.Title)
}

func NewNewTechProjectHandler(pmTarget *project_manager.ProjectManager) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgNewTechProjectKind, func(ipayload interface{}) {
		msg, ok := ipayload.(*MsgNewTechProject)
		if !ok {
			panic(errors.New("invalid payload type"))
		}

		pmTarget.AddProject(msg.Title, msg.Description, project_manager.DivisionTech, msg.Members, msg.Tasks)
	})
}

func NewNewTechProjectMsg(title string) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgNewTechProjectKind, &MsgNewTechProject{Title: title})
}

// EDIT PAYROLLS

const MsgEditPayrollsKind = "gno.land/r/samourai/samdao.EditPayrolls"

type MsgEditPayrolls struct {
	target  std.Address
	payroll uint64
}

func (m *MsgEditPayrolls) String() string {
	return ufmt.Sprintf("Edit payrolls for %s", m.target)
}

func NewEditPayrollsHandler(dao *basedao.DAOPrivate) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgEditPayrollsKind, func(ipayload interface{}) {
		_, ok := ipayload.(*MsgEditPayrolls)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		panic("not implemented")
	})
}

func NewEditPayrollsMsg(target std.Address, payroll uint64) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgEditPayrollsKind, &MsgEditPayrolls{target: target, payroll: payroll})
}

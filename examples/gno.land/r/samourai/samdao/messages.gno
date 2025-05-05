package samdao

import (
	"errors"
	"std"

	"gno.land/p/demo/ufmt"
	"gno.land/p/samourai/basedao"
	"gno.land/p/samourai/daokit"
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
		_, ok := ipayload.(*MsgChangeCEO)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		panic("not implemented")
	})
}

func NewChangeCEOMsg(newCEO std.Address) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgChangeCEOKind, &MsgChangeCEO{NewCEO: newCEO})
}

// NEW POST

const MsgNewPostKind = "gno.land/r/samourai/samdao.NewPost"

type MsgNewPost struct {
	Title   string
	Content string
}

func (m *MsgNewPost) String() string {
	return ufmt.Sprintf("New post: %s", m.Title)
}

func NewNewPostHandler(dao *basedao.DAOPrivate) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgNewPostKind, func(ipayload interface{}) {
		_, ok := ipayload.(*MsgNewPost)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		panic("not implemented")
	})
}

func NewNewPostMsg(title string, content string) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgNewPostKind, &MsgNewPost{Title: title, Content: content})
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
		_, ok := ipayload.(*MsgNewStakeholder)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		panic("not implemented")
	})
}

func NewNewStakeholderMsg(address std.Address) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgNewStakeholderKind, &MsgNewStakeholder{Address: address})
}

// ELECT PROJECT LEAD

const MsgElectProjectLeadKind = "gno.land/r/samourai/samdao.ElectProjectLead"

type MsgElectProjectLead struct {
	ProjectID uint64
	Address   std.Address
}

func (m *MsgElectProjectLead) String() string {
	return ufmt.Sprintf("Elect project lead: %s", m.Address)
}

func NewElectProjectLeadHandler(dao *basedao.DAOPrivate) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgElectProjectLeadKind, func(ipayload interface{}) {
		_, ok := ipayload.(*MsgElectProjectLead)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		panic("not implemented")
	})
}

func NewElectProjectLeadMsg(projectID uint64, address std.Address) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgElectProjectLeadKind, &MsgElectProjectLead{ProjectID: projectID, Address: address})
}

// NEW MEDIA PROJECT

const MsgNewMediaProjectKind = "gno.land/r/samourai/samdao.NewMediaProject"

type MsgNewMediaProject struct {
	Title string
}

func (m *MsgNewMediaProject) String() string {
	return ufmt.Sprintf("New media project: %s", m.Title)
}

func NewNewMediaProjectHandler(dao *basedao.DAOPrivate) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgNewMediaProjectKind, func(ipayload interface{}) {
		_, ok := ipayload.(*MsgNewMediaProject)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		panic("not implemented")
	})
}

func NewNewMediaProjectMsg(title string) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgNewMediaProjectKind, &MsgNewMediaProject{Title: title})
}

// NEW TECH PROJECT

const MsgNewTechProjectKind = "gno.land/r/samourai/samdao.NewTechProject"

type MsgNewTechProject struct {
	Title string
}

func (m *MsgNewTechProject) String() string {
	return ufmt.Sprintf("New tech project: %s", m.Title)
}

func NewNewTechProjectHandler(dao *basedao.DAOPrivate) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgNewTechProjectKind, func(ipayload interface{}) {
		_, ok := ipayload.(*MsgNewTechProject)
		if !ok {
			panic(errors.New("invalid payload type"))
		}
		panic("not implemented")
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

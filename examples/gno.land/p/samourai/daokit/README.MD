# 1. Introduction

A **Decentralized Autonomous Organization (DAO)** is a self-governing entity that operates through smart contracts, enabling transparent decision-making without centralized control.

Daokit is a gnolang package for creating complex DAO models. It introduces a new framework based conditions. BaseDAO is an extension of DAOkit that handles the members & roles through role manager pkg.

# 2. Why daokit ?

The advantages:
- Role system to represent the organization & responsabilities of the members
- Condition system to create complex proposals combining roles, counting, percentages, logical operations, etc.

## 2.1 Key Concepts

To understand how it works, here are three fundamental concepts:

- **Role:** A label assigned to a user (or entity) that grants specific **permissions and governance power** based on the organization’s structure.
- **Resource:** An executable action within the DAO, triggered through the **proposal system**.
- **Condition:** A set of **rules attached to a resource**, which must be met before the corresponding proposal can be executed.

To give an example of how this key concepts interacts, let's consider a DAO that wants to create a proposal to **spend money** from the DAO's treasury.

The DAO's constitution may include the following rules:

- SpendMoney is a resource that allows to spend money from the DAO's treasury.
- To execute a resource a proposal must be created
- A condition is attached to the SpendMoney resource, let's say for the condition to be met the proposal must be supported by 50% of the administration board, and by the Chief Financial Officer (CFO)

In this case:
- Any user can create a proposal to spend money
- Only the votes of the administration board & the CFO will matters
- The proposal will only be executed if it gets the majority of the votes of the administration board & the CFO

# 3. Architecture

the daokit framework is based on the following packages:

## 3.1 daocond

``daocond`` is a package that allows to create conditions (treshold, count, etc) can be combined with roles but is package agnostic and takes function as parameter.

Here is the ``Condition`` and ``State`` interface:

```go
type Condition interface {
	NewState() State

	Render() string
	RenderJSON() *json.Node
}

type State interface {
	Eval(votes map[string]Vote) bool
	HandleEvent(event Event, votes map[string]Vote) // optional but allow to handle some scaling problems

	RenderJSON(votes map[string]Vote) *json.Node
}
```

A condition is a state factory, each proposal is meant to generate a new state based on the condition attached to the resource of the proposal.

## 3.2 daokit

``daokit`` is a package that creates the core of the DAO (resources, proposals). It imports ``daocond`` to attach it to the resource structure.

Here is the ``Core`` structure:

```go
type Core struct {
	Resources *ResourcesStore
	Proposals *ProposalsStore
	NoEvents  bool
}
```

``NoEvents`` is just here to choose if we want to emit events or not.

``daokit`` package also provide an interface for the public usage of the DAO:

```go
type DAO interface {
	Propose(req ProposalRequest) uint64
	Execute(id uint64)
	Vote(id uint64, vote daocond.Vote)
}
```

``daokit`` also provide a ``ExecutableMessage`` and ``MessageHandler`` interface used to create new resources and handlers for DAOs, discover more in the [5.]

## 3.3 role_manager

``role_manager`` is a package that returns a role manager that can be used to attach roles to users and manage them.

Here is the ``RoleManager`` and ``Role`` structure:

```go
type RoleManager struct {
	roles *avl.Tree // role name -> Role
	users *avl.Tree // user addr -> role[]
}

type Role struct {
	name        string
	description string
	permissions *avl.Tree // permission -> struct{}
	users       *avl.Tree // user addr -> struct{}
}
```

The ``permissions`` field is an old artefact of the role manager, but it's not used in our current implementation.

## 3.4 basedao

``basedao`` is a wrapper around daokit that handles the memberstore thanks to the role manager. It also provider the rendering and create some basic resources like add/remove member, add/remove role, etc.

``basedao`` split the DAO in two structures, the ``DAOPrivate`` and the ``daoPublic``.
The difference is that the ``DAOPrivate`` is meant to be used internally by the DAO and not exposed to the outside. By accessing the ``DAOPrivate`` you could modify the DAO core, the memberstore or everything in the DAO. The ``daoPublic`` is the public part of the DAO, it's the part that will be exposed to the outside.
It's an implementation of [``DAO`` interface](#32-daokit) from ``daokit`` package.

To create a new DAO the endpoint is the following:

```go
func New(conf *Config) (daokit.DAO, *DAOPrivate)
```

The ``Config`` structure is the following:

```go
type Config struct {
	Name              string
	Description       string
	ImageURI          string
	Members           *MembersStore
	NoDefaultHandlers bool
	NoEvents          bool
	InitialCondition  daocond.Condition
	SetProfileString  ProfileStringSetter
	GetProfileString  ProfileStringGetter
	NoCreationEvent   bool
}
```

- The ``MembersStore`` can be created with ``basedao.NewMembersStore(...)``
- The ``ProfileStringSetter`` and ``ProfileStringGetter`` are just here to set and get the profile of the DAO. could be the functions from the ``/r/demo/profile`` package for example.
- The ``InitialCondition`` is meant to be attached to the default resources of the DAO.
- The ``NoDefaultHandlers`` is just here to enable/disable the default handlers of the DAO.
- ``NoEvents`` will disable the events emission of the DAO.
- ``NoCreationEvent`` will disable the specific event emitted when the DAO is created.

# 4. Code example of a basic DAO

```go
package daokit_demo

import (
	"gno.land/p/samourai/basedao"
	"gno.land/p/samourai/daocond"
	"gno.land/p/samourai/daokit"
	"gno.land/p/samourai/role_manager"
	"gno.land/r/demo/profile"
)

var (
	DAO        daokit.DAO // exposed to the outside
	daoPrivate *basedao.DAOPrivate // internal use
)

func init() {
	initialRoles := []role_manager.RoleInfo{
		{Name: "admin", Description: "Admin is the superuser"},
		{Name: "public-relationships", Description: "Responsible of communication with the public"},
		{Name: "finance-officer", Description: "Responsible of funds management"},
	}

	initialMembers := []basedao.Member{
		{Address: "g126...zlg", Roles: []string{"admin", "public-relationships"}},
		{Address: "g1ld6...3jv", Roles: []string{"public-relationships"}},
		{Address: "g1r69...0tth", Roles: []string{"finance-officer"}},
		{Address: "g16jv...6e0r", Roles: []string{}},
	}

	DAO, daoPrivate = basedao.New(&basedao.Config{
		Name:             "Demo DAOKIT DAO",
		Description:      "This is a demo DAO built with DAOKIT",
		Members:          basedao.NewMembersStore(initialRoles, initialMembers),
		GetProfileString: profile.GetStringField,
		SetProfileString: profile.SetStringField,
	})
}

func Vote(proposalID uint64, vote daocond.Vote) {
	DAO.Vote(proposalID, vote)
}

func Execute(proposalID uint64) {
	DAO.Execute(proposalID)
}

func Render(path string) string {
	return daoPrivate.Render(path)
}
```

# 5. Create Custom Resources

There is a good chance that you will need to create custom resources for your DAO to met your need. You could also want to create custom resources for your package without being yourself a daokit consumer but to give people the ability to use your package in their DAOs.

To do so, you will need to implement the ``ExecutableMessage`` and ``MessageHandler`` interface.

Here is the interfaces:

```go
type ExecutableMessage interface {
	String() string // return a string representation of the message
	Type() string // return the type of the message (like a slug)
}

type MessageHandler interface {
	Execute(message ExecutableMessage) // execute the message
	Type() string // return the type of the message (like a slug)
}
```

The ``daokit`` package provide a generic implementation of the ``ExecutableMessage`` and ``MessageHandler`` interface to allows users to create in a simple way their own resources. You can take a look at the [``./messages.gno``](./messages.gno) file to see how the generic implementation works.


So to create your own resource follow these steps:

```go
//XXX: pkg /p/samourai/blog (this package does not exist, it's just an example)
// Think about crossing if you write the messages within realm and not package


// 1. Define the kind (slug) of the message, it should be unique 
const MsgNewPostKind = "gno.land/p/samourai/blog.NewPost"

// 2. Define the message structure (the payload of the message)
// It should contain the data needed to execute the message
type MsgNewPost struct {
	Title string
	Content string
}

// 3. Use the generic message handler to create the factory of handlers & messages
func NewPostHandler(blog *Blog) daokit.MessageHandler {
	return daokit.NewMessageHandler(MsgNewPostKind, func(payload interface{}) {
		msg, ok := payload.(*MsgNewPost)
		if !ok {
			panic(errors.New("invalid message type"))
		}
		blog.NewPost(msg.Title, msg.Content)
	})
}

func NewPostMsg(title, content string) daokit.ExecutableMessage {
	return daokit.NewMessage(MsgNewPostKind, &MsgNewPost{
		Title:   title,
		Content: content,
	})
}

---

// 4. Register the handler to the DAO
// XXX: /r/samourai/samdao

// 4.1 Import the package
import (
    "gno.land/p/samorai/blog"
    "gno.land/p/samourai/daokit"
)

var blog *blog.Blog
// 4.2 Register your resources
func init() {
    ...
    blog = blog.NewBlog()

    resource := daokit.Resource{
        Condition: daocond.NewRoleCount(1, "CEO", daoPrivate.Members.HasRole),
        Handler: blog.NewPostHandler(blog),
    }
    daoPrivate.Core.Resources.Set(&resource)
}

```

Now as the author of the package blog, my users can easily use the blog package within their DAO without having to implement the ``ExecutableMessage`` and ``MessageHandler`` interface.

If you want an advanced example of how to use the ``daokit`` package, you can take a look at the ``./r/samourai/samdao`` realm that is a representation of the real-world organization Samourai Coop including project management, payrolls, blog posts ...etc
package daocond_test

import (
	"errors"
	"testing"

	"gno.land/p/demo/urequire"
	"gno.land/p/samourai/daocond"
)

func TestCondition(t *testing.T) {
	dao := newMockDAO()

	// leaf conditions
	membersMajority := daocond.MembersThreshold(0.6, dao.isMember, dao.membersCount)
	publicRelationships := daocond.RoleCount(1, "public-relationships", dao.hasRole)
	financeOfficer := daocond.RoleCount(1, "finance-officer", dao.hasRole)

	urequire.Equal(t, "60% of members", membersMajority.Render())
	urequire.Equal(t, "1 public-relationships", publicRelationships.Render())
	urequire.Equal(t, "1 finance-officer", financeOfficer.Render())

	// ressource expressions
	ressources := map[string]daocond.Condition{
		"social.post":    daocond.And([]daocond.Condition{publicRelationships, membersMajority}),
		"finance.invest": daocond.Or([]daocond.Condition{financeOfficer, membersMajority}),
	}

	urequire.Equal(t, "[1 public-relationships AND 60% of members]", ressources["social.post"].Render())
	urequire.Equal(t, "[1 finance-officer OR 60% of members]", ressources["finance.invest"].Render())

}

type testPhase struct {
	changes func(dao *mockDAO)
	votes   map[string]daocond.Vote
	result  bool
}

type mockDAO struct {
	members   map[string][]string
	roles     map[string][]string
	resources map[string]daocond.Condition
}

func newMockDAO() *mockDAO {
	return &mockDAO{
		members: map[string][]string{
			"alice": []string{"finance-officer"},
			"bob":   []string{"public-relationships"},
			"eve":   []string{},
		},
		roles: map[string][]string{
			"finance-officer":      []string{"alice"},
			"public-relationships": []string{"bob"},
		}, // roles to users
		resources: make(map[string]daocond.Condition),
	}
}

func (m *mockDAO) assignRole(userId string, role string) {
	roles, ok := m.members[userId]
	if !ok {
		panic(errors.New("unknown member"))
	}
	m.members[userId], ok = strsadd(roles, role)
}

func (m *mockDAO) unassignRole(userId string, role string) {
	roles, ok := m.members[userId]
	if !ok {
		panic(errors.New("unknown member"))
	}
	m.members[userId], ok = strsrm(roles, role)
}

func (m *mockDAO) isMember(memberId string) bool {
	_, ok := m.members[memberId]
	return ok
}

func (m *mockDAO) membersCount() uint64 {
	return uint64(len(m.members))
}

func (m *mockDAO) hasRole(memberId string, role string) bool {
	roles, ok := m.members[memberId]
	if !ok {
		return false
	}
	for _, memberRole := range roles {
		if memberRole == role {
			return true
		}
	}
	return false
}

func strsrm(strs []string, val string) ([]string, bool) {
	removed := false
	res := []string{}
	for _, str := range strs {
		if str == val {
			removed = true
			continue
		}
		res = append(res, str)
	}
	return res, removed
}

func strsadd(strs []string, val string) ([]string, bool) {
	for _, str := range strs {
		if str == val {
			return strs, false
		}
	}
	return append(strs, val), true
}

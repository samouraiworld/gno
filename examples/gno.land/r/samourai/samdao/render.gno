package samdao

import (
	"gno.land/p/demo/mux"
	"gno.land/p/demo/ufmt"
	"gno.land/p/samourai/basedao"
)

func Render(path string) string {
	daoPrivate.RenderRouter.HandleFunc(basedao.HOME_PATH, func(res *mux.ResponseWriter, req *mux.Request) {
		res.Write(HomePageView())
	})
	daoPrivate.RenderRouter.HandleFunc(basedao.CONFIG_PATH, daoPrivate.MuxConfigPage)
	daoPrivate.RenderRouter.HandleFunc(basedao.PROPOSAL_HISTORY_PATH, daoPrivate.MuxProposalHistoryPage)
	daoPrivate.RenderRouter.HandleFunc(basedao.MEMBER_DETAIL_PATH, daoPrivate.MuxMemberDetailPage)
	daoPrivate.RenderRouter.HandleFunc(basedao.PROPOSAL_DETAIL_PATH, daoPrivate.MuxProposalDetailPage)
	return daoPrivate.Render(path)
}

func HomeProjectsView() string {
	s := ""
	s += ufmt.Sprintf("## Projects 📚 \n\n")
	projects := pm.ListProjects()
	if len(projects) == 0 {
		s += ufmt.Sprintf("\t⚠️ There are no projects at the moment\n\n")
	} else {
		for _, project := range projects {
			s += ufmt.Sprintf("- **%s**\n", project.Name)
			s += ufmt.Sprintf("  - **Description:** %s\n", project.Description)
		}
	}
	return s
}

func HomePageView() string {
	return daoPrivate.HomePageView() +
		HomeProjectsView()
}

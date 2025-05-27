package samdao

import (
	"std"
	"strings"

	"gno.land/p/demo/mux"
	"gno.land/p/demo/ufmt"
	"gno.land/p/samourai/basedao"
	"gno.land/r/samourai/payrolls"
)

func Render(path string) string {
	daoPrivate.RenderRouter.HandleFunc(basedao.HOME_PATH, func(res *mux.ResponseWriter, req *mux.Request) {
		res.Write(HomePageView())
	})
	daoPrivate.RenderRouter.HandleFunc(basedao.CONFIG_PATH, daoPrivate.MuxConfigPage)
	daoPrivate.RenderRouter.HandleFunc(basedao.PROPOSAL_HISTORY_PATH, daoPrivate.MuxProposalHistoryPage)
	daoPrivate.RenderRouter.HandleFunc(basedao.MEMBER_DETAIL_PATH, daoPrivate.MuxMemberDetailPage)
	daoPrivate.RenderRouter.HandleFunc(basedao.PROPOSAL_DETAIL_PATH, daoPrivate.MuxProposalDetailPage)
	daoPrivate.RenderRouter.HandleFunc("blog", samBlog.RenderHome)
	daoPrivate.RenderRouter.HandleFunc("blog:p/{slug}", samBlog.RenderPost)
	daoPrivate.RenderRouter.HandleFunc("blog:t/{slug}", samBlog.RenderTag)
	daoPrivate.RenderRouter.HandleFunc("payrolls", MuxPayrollsView)
	return daoPrivate.Render(path)
}

func MuxPayrollsView(res *mux.ResponseWriter, req *mux.Request) {
	res.Write(PayrollsPage())
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
			s += ufmt.Sprintf("  - **Members:** \n\n")
			project.Members.Iterate("", "", func(key string, value interface{}) bool {
				member := std.Address(key)
				profile := daoPrivate.GetProfileString(member, "DisplayName", basedao.FALLBACK_DISPLAY_NAME)
				s += ufmt.Sprintf("    - %s\n", profile)
				return false
			})
		}
	}
	s += "----------------------------------------\n\n"
	return s
}

func HomePayrollsView() string {
	pkgPath := daoPrivate.Realm.PkgPath()
	linkPath := getLinkPath(pkgPath)
	s := ""
	s += ufmt.Sprintf("## Payrolls 💰 \n\n")
	s += ufmt.Sprintf("> The payrolls are managed by stakeholders & the accounting team\n\n")
	s += ufmt.Sprintf("To explore the payrolls, see [Payrolls 💰](%s:%s)\n\n", linkPath, "payrolls")
	s += "----------------------------------------\n\n"
	return s
}

func HomeBlogView() string {
	pkgPath := daoPrivate.Realm.PkgPath()
	linkPath := getLinkPath(pkgPath)
	s := ""
	s += ufmt.Sprintf("## Blog 📰 \n\n")
	s += ufmt.Sprintf("> The blog is managed by the marketing team\n\n")
	s += ufmt.Sprintf("To explore the blog, see [Blog 📰](%s:%s)\n\n", linkPath, "blog")
	s += "----------------------------------------\n\n"
	return s
}

func HomePageView() string {
	return daoPrivate.HomePageView() +
		HomeProjectsView() +
		HomePayrollsView() +
		HomeBlogView()
}

func PayrollsPage() string {
	s := ""
	s += payrolls.Render("/v/gno.land/r/samourai/samdao.samdao")
	return s
}

func getLinkPath(pkgPath string) string {
	slashIdx := strings.IndexRune(pkgPath, '/')
	if slashIdx != 1 {
		return pkgPath[slashIdx:]
	}
	return ""
}

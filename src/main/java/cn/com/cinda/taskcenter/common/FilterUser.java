package cn.com.cinda.taskcenter.common;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FilterUser extends HttpServlet implements Filter {

	public FilterUser() {
	}

	public void init(FilterConfig filterConfig) throws ServletException {
		this.filterConfig = filterConfig;
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain filterChain) throws ServletException, IOException

	{
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		httpResponse.addHeader("P3P", "CP=CAO PSA OUR");

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		javax.servlet.http.HttpSession session = httpRequest.getSession();
		java.security.Principal principle = httpRequest.getUserPrincipal();
		if (principle == null) {
			String url = httpRequest.getRequestURI();
			if (!specUri(url)) {
				String rootUri = httpRequest.getContextPath();
				// System.out.println("????????????????" + rootUri);
				httpResponse.sendRedirect(rootUri + "/jsp/msg.jsp");
				return;
			}
			filterChain.doFilter(request, response);
		} else {
			filterChain.doFilter(request, response);
		}
	}

	public void destroy() {
	}

	private boolean specUri(String uri) {
		if (uri.indexOf("/taskctr/jsp/check.jsp") != -1)
			return true;
		if (uri.indexOf("/taskctr/jsp/msg.jsp") != -1)
			return true;
		if (uri.endsWith(".xdp"))
			return true;
		if (uri.endsWith(".xml"))
			return true;
		if (uri.endsWith(".jpg"))
			return true;
		if (uri.endsWith(".gif"))
			return true;
		if (uri.endsWith(".bmp"))
			return true;
		if (uri.endsWith(".js"))
			return true;
		if (uri.endsWith(".css"))
			return true;
		if (uri.endsWith(".jpeg"))
			return true;
		if (uri.endsWith(".ico"))
			return true;
		return uri.endsWith("Service");
	}

	private FilterConfig filterConfig;
}
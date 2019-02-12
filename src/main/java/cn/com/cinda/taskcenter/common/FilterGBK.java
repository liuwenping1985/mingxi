package cn.com.cinda.taskcenter.common;

import java.io.IOException;
import java.security.Principal;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class FilterGBK extends HttpServlet implements Filter {
	private FilterConfig filterConfig;

	// Handle the passed-in FilterConfig
	public void init(FilterConfig filterConfig) throws ServletException {
		this.filterConfig = filterConfig;
	}

	// Process the request/response pair
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain filterChain) {
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		httpResponse.addHeader("P3P", "CP=CAO PSA OUR");
		//httpResponse.setHeader("Pragma", "No-cache"); // HTTP 1.1 
		//httpResponse.setHeader("Cache-Control", "no-cache"); // HTTP 1.0
		//httpResponse.setHeader("Expires", "0"); // proxy no cache

		try {
			HttpServletRequest httpRequest = (HttpServletRequest) request;
			HttpSession session = httpRequest.getSession();
			request.setCharacterEncoding("GBK");

			String uri = httpRequest.getRequestURI();
			
			if (!specUri(uri)) {
				// user not login
				if (!loginUserSuccess((HttpServletRequest) request)) {
					String rootUri = httpRequest.getContextPath();
					httpResponse.sendRedirect(rootUri + "/jsp/msg.jsp");
					return;
				}

				// 判断用户是否已经注销了
				reLogin((HttpServletRequest) request);
			}

			filterChain.doFilter(request, response);
		} catch (ServletException sx) {
			sx.printStackTrace();
			filterConfig.getServletContext().log(sx.getMessage());
		} catch (IOException iox) {
			filterConfig.getServletContext().log(iox.getMessage());
			iox.printStackTrace();
		}
	}

	private boolean loginUserSuccess(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("userId");

		if (userId == null) {
			Principal principal = request.getUserPrincipal();
			if (principal == null) {
				System.out.println("++++++++error+++++++:用户没有登录!");
				String uri = request.getRequestURI();
				System.out.println("没有权限访问:" + uri);
				return false;
			}
			userId = principal.getName();
			session.setAttribute("userId", userId);
		}
		return true;
	}

	private boolean specUri(String uri) {
		if (uri.indexOf("/taskctr/jsp/check.jsp") != -1) {
			return true;
		} else if (uri.endsWith("/jsp/msg.jsp")) {
			return true;
		} else if (uri.endsWith(".xdp")) {
			return true;
		} else if (uri.endsWith(".xml")) {
			return true;
		} else if (uri.endsWith(".jpg")) {
			return true;
		} else if (uri.endsWith(".gif")) {
			return true;
		} else if (uri.endsWith(".bmp")) {
			return true;
		} else if (uri.endsWith(".js")) {
			return true;
		} else if (uri.endsWith(".css")) {
			return true;
		} else if (uri.endsWith(".jpeg")) {
			return true;
		} else if (uri.endsWith(".ico")) {
			return true;
		} else if (uri.endsWith("Service")) {
			return true;
		}else if (uri.endsWith("/taskctr/jsp/mydonelist.jsp")) {
			return true;
		}else if (uri.endsWith("/taskctr/jsp/myworktodo_1.jsp")) {
			return true;
		}else if (uri.endsWith("/taskctr/jsp/newjasonTodolist.jsp")) {
			return true;
		}

		return false;
	}

	private void reLogin(HttpServletRequest request) {
		HttpSession session = request.getSession();
		Principal principal = request.getUserPrincipal();
		String userId = (String) session.getAttribute("userId");

		if(principal!=null)
		{
		String userIdNew = principal.getName();
		if (!userId.equals(userIdNew)) {
			session.setAttribute("userId", userIdNew);
		}
		}
	}

	// Clean up resources
	public void destroy() {
	}
}

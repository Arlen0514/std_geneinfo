package com.genesis.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FatGetBlockFilter implements Filter {
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		if (((request instanceof HttpServletRequest)) && ((response instanceof HttpServletResponse))) {
			HttpServletRequest httpReq = (HttpServletRequest) request;
			HttpServletResponse httpResp = (HttpServletResponse) response;

			String method = httpReq.getMethod();
			if ("GET".equalsIgnoreCase(method)) {
				int contentLength = httpReq.getContentLength();
				if (contentLength > 0) {
					httpResp.sendError(400, "GET request must not contain body");
					return;
				}
				String transferEncoding = httpReq.getHeader("Transfer-Encoding");
				if ((transferEncoding != null) && (!transferEncoding.isEmpty())) {
					httpResp.sendError(400, "GET request with body not allowed");
					return;
				}
			}
		}
		chain.doFilter(request, response);
	}

	public void destroy() {
	}
}

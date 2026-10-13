package com.schoolerp.usermanagement.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.schoolerp.usermanagement.common.response.ErrorResponse;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.time.Instant;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider tokenProvider;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {

        String header = request.getHeader("Authorization");
        if (header == null || !header.startsWith("Bearer ")) {
            chain.doFilter(request, response);   // no token: Spring rejects it if the endpoint is protected
            return;
        }
        String jwt = header.substring(7);

        if (!tokenProvider.validateToken(jwt) || !tokenProvider.validateAccessToken(jwt)) {
            reject(response, "Invalid or expired token");
            return;
        }

        String username = tokenProvider.getUsernameFromJWT(jwt);
        String userId = tokenProvider.getUserIdFromJWT(jwt);

        List<SimpleGrantedAuthority> authorities = tokenProvider.getRolesFromJWT(jwt).stream()
                .map(String::trim).filter(r -> !r.isBlank())
                .map(r -> r.startsWith("ROLE_") ? r.substring(5) : r)
                .map(r -> new SimpleGrantedAuthority("ROLE_" + r))
                .toList();

        if (username == null || authorities.isEmpty()) {
            reject(response, "Token has no user or role");
            return;
        }

        var auth = new UsernamePasswordAuthenticationToken(new AuthUser(userId, username), null, authorities);
        auth.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
        SecurityContextHolder.getContext().setAuthentication(auth);

        chain.doFilter(request, response);
    }

    private void reject(HttpServletResponse response, String message) throws IOException {
        SecurityContextHolder.clearContext();
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");
        response.getWriter().write("{\"message\":\"" + message + "\"}");
    }


}
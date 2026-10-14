package com.schoolerp.usermanagement.config;

import feign.RequestInterceptor;
import feign.RequestTemplate;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Slf4j
@Component
public class FeignAuthInterceptor implements RequestInterceptor {
    @Override
    public void apply(RequestTemplate template) {
        var attrs = RequestContextHolder.getRequestAttributes();
        String auth = (attrs instanceof ServletRequestAttributes sra)
                ? sra.getRequest().getHeader(HttpHeaders.AUTHORIZATION) : null;
        log.info("Feign interceptor ran | requestContext={} | tokenPresent={}", attrs != null, auth != null);
        if (auth != null) template.header(HttpHeaders.AUTHORIZATION, auth);
    }
}

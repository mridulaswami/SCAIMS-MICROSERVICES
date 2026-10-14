package com.schoolerp.usermanagement.config;


import com.schoolerp.usermanagement.common.response.ApiResponse;
import com.schoolerp.usermanagement.modules.Complaint.responseDto.AssetResponseDto;
import com.schoolerp.usermanagement.modules.Complaint.responseDto.UserResponseDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.UUID;

@FeignClient(name = "scaims-user-service" , path ="/scaims-user-service/api/v1/users")
public interface UserClient {

    @GetMapping("/{id}")
    ApiResponse<UserResponseDto> getUserById (@PathVariable("id") UUID id);

}

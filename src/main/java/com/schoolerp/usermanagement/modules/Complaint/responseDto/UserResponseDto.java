package com.schoolerp.usermanagement.modules.Complaint.responseDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponseDto {

    private UUID id;

    private String userName;

    private String name;

    private List<String> roleName;

    private String phoneNumber;

    private String email;

    private Boolean status;

    private LocalDateTime createdAt;

    private String wardAssigned;
}

package com.schoolerp.usermanagement.modules.Complaint.responseDto;

import com.schoolerp.usermanagement.modules.Geometry.GeometryDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Geometry;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AssetResponseDto {

    private UUID id;

    private String name;

    private String categoryName;

    private UUID categoryId;

    private UUID assetCategory;

    private Geometry geometry;

    private String status;

    private String condition;

    private String ward;

    private LocalDateTime installedDate;

    private LocalDateTime lastInspectedDate;

}

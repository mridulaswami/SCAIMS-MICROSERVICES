package com.schoolerp.usermanagement.modules.Complaint.entity;

import com.schoolerp.usermanagement.modules.WorkOrder.entity.WorkOrderEntity;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.locationtech.jts.geom.Geometry;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Table(name = "complaint")
@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ComplaintEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;


    private UUID citizenId;

    @Column(name = "title")
    private String title;


    private UUID assetId;

    @Column(name = "description")
    private String description;

    @Column(name = "location", columnDefinition = "geometry(Point,4326)")
    private Geometry location;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private Status status = Status.SUBMITTED;

//    @OneToOne
//    @JoinColumn(name = "linked_work_order_id")
//    private WorkOrderEntity linkedWorkOrderId;

    @OneToMany(mappedBy = "complaintId", fetch = FetchType.EAGER)
    private List<WorkOrderEntity> workOrder;

    @OneToMany(mappedBy = "complaint", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ComplaintPhotosEntity> complaintPhotos;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", updatable = true)
    private LocalDateTime updatedAt;

    @Column(name="pid", updatable = false)
    private String pid;

    public enum Status {
        SUBMITTED, INPROGESS, REJECTED, COMPLETED
    }
}
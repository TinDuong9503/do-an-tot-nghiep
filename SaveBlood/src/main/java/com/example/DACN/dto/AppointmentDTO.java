package com.example.DACN.dto;

import com.example.DACN.model.Event;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Data
@Builder

public class AppointmentDTO {
    private Long id ;
    private LocalDateTime appointmentDateTime;
    private Integer bloodAmount;
    private String status;
    private Long bloodDonationHistoryId;
    private Long healthCheckId;
    private String userId;
    private String eventId;
    private LocalDateTime nextDonationEligibleDate;
    private Long bloodInventoryId;
}

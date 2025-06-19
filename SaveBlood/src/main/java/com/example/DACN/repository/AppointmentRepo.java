package com.example.DACN.repository;

import com.example.DACN.model.Appointment;
import com.example.DACN.model.status.AppointmentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AppointmentRepo extends JpaRepository<Appointment, Long> {
    List<Appointment> findByUser_Username(String userId);

    Optional<Appointment> findByUserUsernameAndStatus(String username, AppointmentStatus status);

    void deleteByIdIn(List<Long> ids);

    @Query("SELECT a.bloodInventory.id FROM Appointment a WHERE a.Id IN :appointmentIds")
    List<Long> findBloodInventoryIdsByAppointments(List<Long> appointmentIds);

    @Query("SELECT a FROM Appointment a WHERE a.bloodInventory.id = :id")
    Appointment findByBloodInventoryId(Long id);
}


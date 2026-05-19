package com.dms.repository;

import com.dms.entity.User;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserRepository  extends JpaRepository<User, Integer> {

    User findByEmail(String email);
    User findByIdAndEnabledTrue(int id);
    User findByUsername(String username);

    User findByUsernameAndEnabledTrue(String username);
    User findByEmailAndEnabledTrue(String email);
    long countByRoleAndEnabledTrue(String role);
    List<User> findAllByRoleAndIsSuperAdminFalseAndEnabledTrue(String role);

    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.enabled=false WHERE u.id=:adminId")
    void disableAdminById(@Param("adminId") String adminId);

    List<User> findAllByRoleAndEnabledTrue(String role);
}

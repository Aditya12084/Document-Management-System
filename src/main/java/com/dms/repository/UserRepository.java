package com.dms.repository;

import com.dms.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository  extends JpaRepository<User, Integer> {
    User findByUsername(String username);
    User findByEmail(String email);
    long countByRole(String role);
}

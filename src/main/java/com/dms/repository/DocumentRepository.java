package com.dms.repository;

import com.dms.entity.Document;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DocumentRepository extends JpaRepository<Document,Integer> {
    Document findById(int id);
}

package com.dms.repository;

import com.dms.entity.Document;
import org.springframework.data.jpa.repository.JpaRepository;

import javax.print.Doc;
import java.util.List;

public interface DocumentRepository extends JpaRepository<Document,Integer> {
    Document findById(int id);
    long countByStatus(String status);
    List<Document> findByStatusOrderByUploadDateAsc(String status);
    List<Document> findTop5ByOrderByUploadDateDesc();
    List<Document> findTop5ByStatusModificationTimeIsNotNullOrderByStatusModificationTimeDesc();
}

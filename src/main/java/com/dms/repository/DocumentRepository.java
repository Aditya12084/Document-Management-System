package com.dms.repository;

import com.dms.entity.Document;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import javax.print.Doc;
import java.util.List;
import java.util.Optional;

public interface DocumentRepository extends JpaRepository<Document,Integer> {
    Document findByIdAndIsActiveTrue(int id);

    int countByStatusIsNotNull();
    long countByTargetUserIdIsNullAndIsActiveTrue();

    long countByStatusAndTargetUserIdIsNullAndIsActiveTrue(String status);

    List<Document> findByStatusAndTargetUserIdIsNullAndIsActiveTrueOrderByUploadDateAsc(String status);

    List<Document> findTop5ByTargetUserIdIsNullAndIsActiveTrueOrderByUploadDateDesc();

    List<Document> findTop5ByStatusModificationTimeIsNotNullAndTargetUserIdIsNullAndIsActiveTrueOrderByStatusModificationTimeDesc();

    List<Document> findAllByTargetUserIdIsNullAndIsActiveTrueOrderByUploadDateDesc();

    List<Document> findAllByUploadedByAndStatusAndIsActiveTrueOrderByUploadDateDesc(Integer id,String status);

    List<Document> findTop5ByTargetUserIdAndIsActiveTrueOrderByUploadDateDesc(Integer targetUserId);

    List<Document> findTop5ByUploadedByAndStatusAndIsActiveTrueOrderByStatusModificationTimeDesc(Integer id,String status);

    List<Document> findAllByUploadedByAndIsActiveTrueOrderByUploadDateDesc(Integer id);

    List<Document> findAllByTargetUserIdAndIsActiveTrueOrderByUploadDateDesc(Integer targetUserId);

    @Modifying
    @Transactional
    @Query("UPDATE Document d SET d.isActive=false WHERE d.id=:docId")
    void deactivateById(@Param("docId") Integer docId);

}

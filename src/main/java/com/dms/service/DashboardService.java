package com.dms.service;


import com.dms.dto.admin.ActivityDTO;
import com.dms.dto.common.DocumentDTO;
import com.dms.entity.Document;
import com.dms.entity.User;
import com.dms.repository.DocumentRepository;
import com.dms.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class DashboardService {

    @Autowired
    private UserRepository userRepo;

    @Autowired
    private DocumentRepository docRepo;

    public HashMap<String,Object> getStats(){
        HashMap<String,Object> stats=new HashMap<>();

        stats.put("users",userRepo.count()-userRepo.countByRole("ADMIN"));
        stats.put("admins",userRepo.countByRole("ADMIN"));
        stats.put("docs",docRepo.countByTargetUserIdIsNull());

        long totalDocs=docRepo.count();

        if (totalDocs>0){
            stats.put("pending",docRepo.countByStatusAndTargetUserIdIsNull("PENDING")*100/totalDocs);
            stats.put("rejected",docRepo.countByStatusAndTargetUserIdIsNull("REJECTED")*100/totalDocs);
            stats.put("approved",docRepo.countByStatusAndTargetUserIdIsNull("approved")*100/totalDocs);
        }
        else{
            stats.put("pending",0);
            stats.put("rejected",0);
            stats.put("approved",0);
        }

        return stats;

    }

    public List<Document> getPendingDocuments(){
        return docRepo.findByStatusAndTargetUserIdIsNullOrderByUploadDateAsc("PENDING");
    }

    public  List<Document> getRecentDocuments(){
        return  docRepo.findTop5ByTargetUserIdIsNullOrderByUploadDateDesc();
    }

    public  List<ActivityDTO> getRecentActivity(){
        List<Document> docs=docRepo.findTop5ByStatusModificationTimeIsNotNullAndTargetUserIdIsNullOrderByStatusModificationTimeDesc();
        List<ActivityDTO> activityList=new ArrayList<>();

        String adminName = "System";
        String owner="";
        for (Document doc: docs){
            adminName = "System";
            owner="System";

            if (doc.getStatusModifiedByAdminId()!=null){
                User admin=userRepo.findById(doc.getStatusModifiedByAdminId()).orElse(null);
                if (admin != null) {
                    adminName = admin.getFullName();
                }
            }

            if (doc.getUploadedBy()!=null){
                User user=userRepo.findById(doc.getUploadedBy()).orElse(null);
                if (user!=null){
                    owner=user.getFullName();
                }
            }

            activityList.add(new ActivityDTO(
                    doc.getFilename(),owner,adminName,doc.getStatus(),doc.getStatusModificationTime()));

        }

        return activityList;
    }

    public List<DocumentDTO> getSubmissions(){

        List<Document> docs=docRepo.findAllByTargetUserIdIsNullOrderByUploadDateDesc();
        List<DocumentDTO> submissionsList=new ArrayList<>();

        String owner="System";

        for (Document doc: docs){
            owner="System";
            if (doc.getUploadedBy()!=null){
                User user=userRepo.findById(doc.getUploadedBy()).orElse(null);
                if (user!=null){
                    owner=user.getFullName();
                }
            }
            submissionsList.add(new DocumentDTO(doc.getId(),owner,doc.getFilename(),doc.getUploadDate(),doc.getRejectionRemark(),doc.getStatus(),doc.getDocCategory(),null,null));
        }

        return submissionsList;
    }

}

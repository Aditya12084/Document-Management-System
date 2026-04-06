package com.dms.service;


import com.dms.dto.ActivityDTO;
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
        stats.put("docs",docRepo.count());

        long totalDocs=docRepo.count();

        if (totalDocs>0){
            stats.put("pending",docRepo.countByStatus("PENDING")*100/totalDocs);
            stats.put("rejected",docRepo.countByStatus("REJECTED")*100/totalDocs);
            stats.put("approved",docRepo.countByStatus("approved")*100/totalDocs);
        }
        else{
            stats.put("pending",0);
            stats.put("rejected",0);
            stats.put("approved",0);
        }

        return stats;

    }

    public List<Document> getPendingDocuments(){
        return docRepo.findByStatusOrderByUploadDateAsc("PENDING");
    }

    public  List<Document> getRecentDocuments(){
        return  docRepo.findTop5ByOrderByUploadDateDesc();
    }

    public  List<ActivityDTO> getRecentActivity(){
        List<Document> docs=docRepo.findTop5ByStatusModificationTimeIsNotNullOrderByStatusModificationTimeDesc();
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

}

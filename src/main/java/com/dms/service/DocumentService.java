package com.dms.service;

import com.dms.dto.common.DocumentDTO;
import com.dms.entity.Document;
import com.dms.repository.DocumentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class DocumentService {

    @Autowired
    private DocumentRepository repo;

    public void saveDocument(Document doc){
        repo.save(doc);
    }

    public Document getDocumentById(int id){
        return repo.findById(id);
    }


    public List<DocumentDTO> getDocumentsByStatus(Integer id,String status){
        List<DocumentDTO> documentDTOList= new ArrayList<>();

        if (status.equals("PENDING")){
            List<Document> docs=repo.findAllByUploadedByAndStatusAndIsActiveTrueOrderByUploadDateDesc(id,status);

            for (Document doc : docs){
                documentDTOList.add(new DocumentDTO(doc.getId(),"",doc.getFilename(),doc.getUploadDate(),doc.getRejectionRemark(),"",doc.getDocCategory(),doc.getFileSize(),null));
            }
        }
        if (status.equals("REJECTED")){
            List<Document> docs=repo.findTop5ByUploadedByAndStatusAndIsActiveTrueOrderByStatusModificationTimeDesc(id,"REJECTED");

            for (Document doc : docs){
                documentDTOList.add(new DocumentDTO(doc.getId(),"",doc.getFilename(),null,doc.getRejectionRemark(),"",doc.getDocCategory(),doc.getFileSize(),doc.getStatusModificationTime()));
            }
        }


        return documentDTOList;
    }

    public List<DocumentDTO> getRecentSharesService(Integer id){
        List<Document> recentShares=repo.findTop5ByTargetUserIdAndIsActiveTrueOrderByUploadDateDesc(id);
        List<DocumentDTO> documentDTOList= new ArrayList<>();

        for (Document doc : recentShares){
            documentDTOList.add(new DocumentDTO(doc.getId(),"",doc.getFilename(),
                    doc.getUploadDate(),"","",doc.getDocCategory(),
                    doc.getFileSize(),null));
        }

        return documentDTOList;
    }

    public List<DocumentDTO> getMyDocumentsService(Integer id){
        List<Document> recentShares=repo.findAllByUploadedByAndIsActiveTrueOrderByUploadDateDesc(id);
        List<DocumentDTO> documentDTOList= new ArrayList<>();

        for (Document doc : recentShares){
            documentDTOList.add(new DocumentDTO(doc.getId(),"",doc.getFilename(),
                    doc.getUploadDate(),doc.getRejectionRemark(),doc.getStatus(),doc.getDocCategory(),
                    doc.getFileSize(),null));
        }

        return documentDTOList;
    }

     public List<DocumentDTO> getReceivedDocumentsService(Integer id){
            List<Document> recentShares=repo.findAllByTargetUserIdAndIsActiveTrueOrderByUploadDateDesc(id);
            List<DocumentDTO> documentDTOList= new ArrayList<>();

            for (Document doc : recentShares){
                documentDTOList.add(new DocumentDTO(doc.getId(),"",doc.getFilename(),
                        doc.getUploadDate(),"",doc.getStatus(),doc.getDocCategory(),
                        null,null));
            }

            return documentDTOList;
     }

     public void removeDocumentService(int id){
        repo.deactivateById(id);
     }

}

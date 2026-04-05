package com.dms.service;


import com.dms.entity.Document;
import com.dms.repository.DocumentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

}

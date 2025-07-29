from langchain.storage import InMemoryStore
from langchain.retrievers.multi_vector import MultiVectorRetriever
from langchain.schema import Document
import uuid

def store_documents(retriever, elements, summaries, id_key):
    ids = [str(uuid.uuid4()) for _ in elements]

    # Create summary documents with metadata
    summary_docs = [
        Document(page_content=summaries[i], metadata={id_key: ids[i]})
        for i in range(len(summaries))
        if summaries[i] and summaries[i].strip()  # ✅ Filter out empty summaries
    ]

    if not summary_docs:
        raise ValueError("❌ No valid summaries to store. All were empty or invalid.")

    # # ✅ Debug print to inspect documents being stored
    # for i, doc in enumerate(summary_docs):
    #     print(f"[{i}] Page Content: {repr(doc.page_content)}, Metadata: {doc.metadata}")

    # ✅ Add summaries to vector store
    retriever.vectorstore.add_documents(summary_docs)

    # Store full elements WITH metadata (so it can show up in retrieval)
    retriever.docstore.mset([
        (ids[i], Document(
            page_content=getattr(elements[i], "text", str(elements[i])),  # safely extract text
            metadata={id_key: ids[i]}
        ))
        for i in range(len(elements))
    ])

def setup_retriever(vectorstore):
    store = InMemoryStore()
    retriever = MultiVectorRetriever(vectorstore=vectorstore, docstore=store, id_key="doc_id")
    return retriever

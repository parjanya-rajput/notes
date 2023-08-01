class CloudStorageException implements Exception{
  const CloudStorageException();
}

class CouldNotCreateNote extends CloudStorageException {}
class CouldNotGetAllNotes extends CloudStorageException {}
class CouldNotUpdateNoteException extends CloudStorageException {}
class CouldNotDeleteNoteException extends CloudStorageException {}
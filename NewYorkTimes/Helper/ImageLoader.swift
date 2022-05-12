//
//  ImageLoader.swift
//  NewYorkTimes
//
//  Created by Nidhi Suhagiya on 12/05/22.
//

import UIKit

class ImageLoader {
    
    static let sharedInstance = ImageLoader()
    
    private init() {}
    
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
//        Check if Url exists as a key in memory cache
        if let img = loadedImages[url] {
            completion(.success(img))
            return nil
        }
        
//        UUID instance that is used to identify the data task
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //  remove the running task, once it is completed
            defer {self.runningRequests.removeValue(forKey: uuid) }

            // extract image from the result and cached the image in memory, then call completion handler with image
            if let data = data, let image = UIImage(data: data) {
              self.loadedImages[url] = image
              completion(.success(image))
              return
            }

            // Handle error
            guard let error = error else {
              // without an image or an error, we'll just ignore this for now
              // you could add your own special error cases for this scenario
              return
            }

//            Check the error reason. If it is because of task being canceled. If the error is anything other than canceling the task, we forward that to the caller of loadImage(_:completion:)
            guard (error as NSError).code == NSURLErrorCancelled else {
              completion(.failure(error))
              return
            }

            // the request was cancelled, no need to call the callback
          }
          task.resume()

          // task is stored in running request dictionary using UUID
          runningRequests[uuid] = task
          return uuid
        
    }
    
//    find a running data task and cancels that task. Also removes the task from the running tasks dictionary, if it exists
    func cancelLoad(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }
}



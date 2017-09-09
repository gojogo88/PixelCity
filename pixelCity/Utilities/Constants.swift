//
//  Constants.swift
//  pixelCity
//
//  Created by Jonathan Go on 2017/09/09.
//  Copyright © 2017 Appdelight. All rights reserved.
//

//swift file

import Foundation

let apiKey = "752e9b007c916689d2f0426d1ebc958d"

func flickrURL(forApiKey key: String, withAnnotation annotation: DroppablePin, andNumberOfPhotos number: Int) -> String {
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"

}

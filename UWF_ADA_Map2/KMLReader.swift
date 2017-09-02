//
//  KMLReader.swift
//  UWF_ADA_Map2
//
//  Created by Tyler Webb on 4/21/16.
//  Copyright © 2016 Yingda Zheng. All rights reserved.
//

import Foundation


open class LookAt
{
    var longitude : Double;
    var latitude : Double;
    var altitude : Double;
    var heading : Double;
    var tilt : Double;
    var range : Double;
    
    init(longitude : Double, latitude : Double, altitude : Double, heading : Double, tilt : Double, range : Double)
    {
        self.longitude = longitude;
        self.latitude = latitude;
        self.altitude = altitude;
        self.heading = heading;
        self.tilt = tilt;
        self.range = range;
        
    }
}

open class Placemark
{
    var name : String
    var visibility : Bool
    var styleURL : String
    var polygons : [Polygon]
    var lookAt : LookAt
    var coordinates : [Coordinate]
    var description : String
    
    init(name : String, visibility : Bool, styleURL : String, polygons : [Polygon], lookAt : LookAt, coordinates : [Coordinate], description: String)
    {
        self.name = name
        self.visibility = visibility
        self.styleURL = styleURL
        self.polygons = polygons
        self.lookAt = lookAt
        self.coordinates = coordinates
        self.description = description
    }
}

enum AltitudeMode
{
    case relativeToGround
}

open class Polygon
{
    var extrude : Bool;
    var altitudeMode : String;
    var coordinates : [Coordinate];
    
    init(extrude : Bool, altitudeMode : String, coordinates : [Coordinate])
    {
        self.extrude = extrude
        self.altitudeMode = altitudeMode
        self.coordinates = coordinates
    }
}

public struct Coordinate{
    var X : Double;
    var Y : Double;
    var Z : Double;
}

open class Folder
{
    var name : String;
    var visibility : Bool;
    var description : String;
    var folders : [Folder];
    var lookAts : [LookAt];
    var placemarks : [Placemark]
    
    init(name : String, visibility : Bool, description : String, folders : [Folder], lookAts : [LookAt], placemarks : [Placemark])
    {
        self.name = name
        self.visibility = visibility
        self.description = description
        self.folders = folders
        self.lookAts = lookAts
        self.placemarks = placemarks
    }
}
extension String {
    
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end = String.CharacterView.index(start, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}
func MatchField(_ data : [Character], currentPosition : Int) -> ([Character], Bool, Int)
{
    var currentPosition = currentPosition
    while (data[currentPosition] == "\n" || data[currentPosition] == " ")
    {
        currentPosition += 1;
    }
    var result : [Character] = [Character]()
    var isClosing : Bool = false;
    
    while (data[currentPosition] != "<")
    {
        currentPosition += 1;
    }
    currentPosition += 1;
    if (data[currentPosition] == "/")
    {
        currentPosition += 1;
        isClosing = true;
    }
    //var cfPos : Int = 0
    while (data[currentPosition] != ">")
    {
        result.append(data[currentPosition++])
    }
    currentPosition += 1
    return (result, isClosing, currentPosition);
}
func PeekFieldExists(_ data : [Character], currentPosition : Int, toCheck : String) -> (Int, Bool, Bool)
{
    var currentPosition = currentPosition
    while (data[currentPosition] == "\n" || data[currentPosition] == " ")
    {
        currentPosition += 1;
    }
    var result : [Character] = [Character]()
    var isClosing : Bool = false;
    if (data[currentPosition] != "<")
    {
        return (currentPosition, false, false)
    }
    while (data[currentPosition] != "<")
    {
        currentPosition += 1;
    }
    currentPosition += 1;
    if (data[currentPosition] == "/")
    {
        currentPosition += 1;
        isClosing = true;
    }
    //var cfPos : Int = 0
    while (data[currentPosition] != ">")
    {
        result.append(data[currentPosition++])
    }
    currentPosition += 1
    return (currentPosition, String(result).compare(toCheck) == ComparisonResult(rawValue: 0), isClosing)
}

func MatchString(_ data: [Character], currentPosition : Int) -> (String, Int)
{
    var currentPosition = currentPosition
    while (data[currentPosition] == "\n" || data[currentPosition] == " ")
    {
        currentPosition += 1;
    }
    var result : [Character] = [Character]()
    
    while (data[currentPosition] != "<")
    {
        result.append(data[currentPosition++])
    }
    return (String(result), currentPosition);
}
func MatchDouble(_ data: [Character], currentPosition : Int) -> (Double, Int)
{
    var currentPosition = currentPosition
    while (data[currentPosition] == "\n" || data[currentPosition] == " ")
    {
        currentPosition += 1;
    }
    var result : [Character] = [Character]()
    
    while (data[currentPosition] != "<" && data[currentPosition] != ",")
    {
        result.append(data[currentPosition++])
    }
    return (Double(String(result))!, currentPosition);
}
func MatchBoolean(_ data : [Character], currentPosition : Int) -> (Bool, Int)
{
    var currentPosition = currentPosition
    while (data[currentPosition] == "\n" || data[currentPosition] == " ")
    {
        currentPosition += 1;
    }
    //print(String(data[currentPosition]))
    if (data[currentPosition] == "0")
    {
        currentPosition += 1;
        return (false, currentPosition)
    }
    else if (data[currentPosition] == "1")
    {
        currentPosition += 1;
        return (true, currentPosition)
    }
    else
    {
        //print("error")
        return (false, -1)
    }
}
/*
func MatchFolder(data : String, var currentPosition : Int) -> (Folder, Int)
{
    var name: String = ""
    var visibility: Bool = false
    var description: String = ""
    var folders: [Folder] = [Folder]()
    var lookAts: [LookAt] = [LookAt]()
    var placemarks: [Placemark] = [Placemark]()
    
    while (true)
    {
        var resultField = MatchField(data, currentPosition: currentPosition)
        currentPosition = resultField.2
        if (resultField.0.compare("name") == NSComparisonResult(rawValue: 0))
        {
            let resultString = MatchString(data, currentPosition: currentPosition)
            currentPosition = resultString.1
            name = resultString.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        if (resultField.0.compare("visibility") == NSComparisonResult(rawValue: 0))
        {
            let resultBool = MatchBoolean(data, currentPosition: currentPosition)
            currentPosition = resultBool.1
            visibility = resultBool.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        if (resultField.0.compare("description") == NSComparisonResult(rawValue: 0))
        {
            let resultString = MatchString(data, currentPosition: currentPosition)
            currentPosition = resultString.1
            description = resultString.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        if (resultField.0.compare("Folder") == NSComparisonResult(rawValue: 0) && resultField.1 == false)
        {
            let resultFolder = MatchFolder(data, currentPosition: currentPosition)
            currentPosition = resultFolder.1
            folders.append(resultFolder.0)
        }
        if (resultField.0.compare("LookAt") == NSComparisonResult(rawValue: 0) && resultField.1 == true)
        {
            let resultLookAt = MatchLookAt(data, currentPosition: currentPosition)
            currentPosition = resultLookAt.1
            lookAts.append(resultLookAt.0)
        }
        if (resultField.0.compare("Placemark") == NSComparisonResult(rawValue: 0) && resultField.1 == true)
        {
            let resultPlacemark = MatchPlaceMark(data, currentPosition: currentPosition)
            currentPosition = resultPlacemark.1
            placemarks.append(resultPlacemark.0)
        }
        if (resultField.0.compare("Folder") == NSComparisonResult(rawValue: 0) && resultField.1 == true)
        {
            //print(String(data[currentPosition]))
            let resultFolder = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultFolder.2
            break
        }
    }
    return (Folder(name: name, visibility: visibility, description: description, folders: folders, lookAts: lookAts, placemarks: placemarks), currentPosition)
}
*/
func MatchLookAt(_ data : [Character], currentPosition : Int) -> (LookAt, Int)
{
    var currentPosition = currentPosition
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    let altitude: Double = 0.0
    let heading: Double = 0.0
    let tilt: Double = 0.0
    var range: Double = 0.0
    
    if (currentPosition == 0){
        range = 0.0;}
    
    while (true)
    {
        
        if (currentPosition == 0){
            range = 0.0;}
        var resultField = MatchField(data, currentPosition: currentPosition)
        currentPosition = resultField.2
        //print(resultField.0)
        //print("lookAt0")
        if (CompareCArray(resultField.0, cArray2: ["l", "o", "n", "g", "i", "t", "u", "d", "e"]))
        {
            //print("lookAt1")
            let resultDouble = MatchDouble(data, currentPosition: currentPosition)
            currentPosition = resultDouble.1
            longitude = resultDouble.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        else if (CompareCArray(resultField.0, cArray2: ["l", "a", "t", "i", "t", "u", "d", "e"]))
        {
            //print("lookAt2")
            let resultDouble = MatchDouble(data, currentPosition: currentPosition)
            currentPosition = resultDouble.1
            latitude = resultDouble.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        /*else if (resultField.0.compare("altitude") == NSComparisonResult(rawValue: 0))
        {
            //print("lookAt3")
            let resultDouble = MatchDouble(data, currentPosition: currentPosition)
            currentPosition = resultDouble.1
            altitude = resultDouble.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        else if (resultField.0.compare("heading") == NSComparisonResult(rawValue: 0))
        {
            //print("lookAt4")
            let resultDouble = MatchDouble(data, currentPosition: currentPosition)
            currentPosition = resultDouble.1
            heading = resultDouble.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        else if (resultField.0.compare("tilt") == NSComparisonResult(rawValue: 0))
        {
            //print("lookAt5")
            let resultDouble = MatchDouble(data, currentPosition: currentPosition)
            currentPosition = resultDouble.1
            tilt = resultDouble.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        else if (resultField.0.compare("range") == NSComparisonResult(rawValue: 0))
        {
            //print("lookAt6")
            let resultDouble = MatchDouble(data, currentPosition: currentPosition)
            currentPosition = resultDouble.1
            range = resultDouble.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }*/
            
            
        else if (CompareCArray(resultField.0, cArray2 : ["L", "o", "o", "k", "A",  "t"]) && resultField.1 == true)
        {
            //print("lookAt7")
            //print(currentPosition)
            break
            
        }
        
    }
    return (LookAt(longitude: longitude, latitude: latitude, altitude: altitude, heading: heading, tilt: tilt, range: range), currentPosition)
}
func MatchPlaceMark(_ data : [Character], currentPosition : Int) -> (Placemark, Int)
{
    var currentPosition = currentPosition
    var name: String = ""
    var visibility: Bool = false
    var styleURL: String = ""
    let polygons: [Polygon] = [Polygon]()
    var lookAt : LookAt = LookAt(longitude: 0.0, latitude: 0.0, altitude: 0.0, heading: 0.0, tilt: 0.0, range: 0.0)
    var coordinates : [Coordinate] = [Coordinate]()
    var description: String = ""
    
    if (currentPosition == 0){
        visibility = false;}
    while (true)
    {
        
        if (currentPosition == 0){
            visibility = false;}
        var resultField = MatchField(data, currentPosition: currentPosition)
        currentPosition = resultField.2
        //print("madeit0")
        //print(resultField)
        if (CompareCArray(resultField.0, cArray2: ["n", "a", "m", "e"]))
        {
            //print("madeit1")
            
            let resultString = MatchString(data, currentPosition: currentPosition)
            currentPosition = resultString.1
            name = resultString.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        else if (CompareCArray(resultField.0, cArray2: ["d", "e", "s", "c", "r", "i", "p", "t", "i", "o", "n"]))
        {
            let resultString = MatchString(data, currentPosition: currentPosition)
            currentPosition = resultString.1
            description = resultString.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        else if (CompareCArray(resultField.0, cArray2: ["v", "i", "s", "i", "b", "i", "l", "i", "t", "y"]))
        {
            //print("madeit2")
            let resultBool = MatchBoolean(data, currentPosition: currentPosition)
            currentPosition = resultBool.1
            visibility = resultBool.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        else if (CompareCArray(resultField.0, cArray2: ["s", "t", "y", "l", "e", "U", "r", "l"]))
        {
            //print("madeit3")
            let resultString = MatchString(data, currentPosition: currentPosition)
            currentPosition = resultString.1
            styleURL = resultString.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        else if (CompareCArray(resultField.0, cArray2: ["L", "o", "o", "k", "A", "t"]))
        {
            //print("madeit4")
            let resultLookAt = MatchLookAt(data, currentPosition: currentPosition)
            currentPosition = resultLookAt.1
            lookAt = resultLookAt.0
            //print(currentPosition)
            //print("made it")
        }
        else if (CompareCArray(resultField.0, cArray2: ["c", "o", "o", "r", "d", "i", "n", "a", "t", "e", "s"]))
        {
            while (true)
            {
                var coordinate : Coordinate = Coordinate(X : 0.0, Y : 0.0, Z : 0.0)
                let c : Character = data[currentPosition]
                //print(c)
                
                var resultDouble = MatchDouble(data, currentPosition: currentPosition)
                currentPosition = resultDouble.1
                coordinate.X = resultDouble.0
                currentPosition += 1;//comma
                resultDouble = MatchDouble(data, currentPosition: currentPosition)
                currentPosition = resultDouble.1
                coordinate.Y = resultDouble.0
                currentPosition += 1;//comma
                resultDouble = MatchDouble(data, currentPosition: currentPosition)
                currentPosition = resultDouble.1
                coordinate.Z = resultDouble.0
                coordinates.append(coordinate)
                let resultField = PeekFieldExists(data, currentPosition : currentPosition, toCheck : "coordinates")
                
                if (resultField.1 && resultField.2 == true)
                {
                    
                    currentPosition = resultField.0
                    break
                }
            }
        }
            /*
        else if (resultField.0.compare("Polygon") == NSComparisonResult(rawValue: 0))
        {
            //print("madeit5")
            let resultPolygon = MatchPolygon(data, currentPosition: currentPosition)
            currentPosition = resultPolygon.1
            polygons.append(resultPolygon.0)
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }*/
        else if (CompareCArray(resultField.0, cArray2: ["P", "l", "a", "c", "e", "m", "a", "r", "k"]) && resultField.1 == true)
        {
            //print("madeit6")
            break
        }
    }
    return (Placemark(name: name, visibility: visibility, styleURL: styleURL, polygons: polygons, lookAt: lookAt, coordinates : coordinates, description: description), currentPosition)
}/*
func MatchPolygon(data : String, var currentPosition : Int) -> (Polygon, Int)
{
    var extrude: Bool = false
    var altitudeMode: String = ""
    var coordinates: [Coordinate] = [Coordinate]()
    
    while (true)
    {
        var resultField = MatchField(data, currentPosition: currentPosition)
        currentPosition = resultField.2
        if (resultField.0.compare("extrude") == NSComparisonResult(rawValue: 0))
        {
            let resultBool = MatchBoolean(data, currentPosition: currentPosition)
            currentPosition = resultBool.1
            extrude = resultBool.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        else if (resultField.0.compare("altitudeMode") == NSComparisonResult(rawValue: 0))
        {
            let resultString = MatchString(data, currentPosition: currentPosition)
            currentPosition = resultString.1
            altitudeMode = resultString.0
            resultField = MatchField(data, currentPosition: currentPosition)
            currentPosition = resultField.2
        }
        else if (resultField.0.compare("coordinates") == NSComparisonResult(rawValue: 0))
        {
            while (true)
            {
                var coordinate : Coordinate = Coordinate(X : 0.0, Y : 0.0, Z : 0.0)
                let c : Character = data[currentPosition]
                //print(c)
                
                var resultDouble = MatchDouble(data, currentPosition: currentPosition)
                currentPosition = resultDouble.1
                coordinate.X = resultDouble.0
                currentPosition++;//comma
                resultDouble = MatchDouble(data, currentPosition: currentPosition)
                currentPosition = resultDouble.1
                coordinate.Y = resultDouble.0
                currentPosition++;//comma
                resultDouble = MatchDouble(data, currentPosition: currentPosition)
                currentPosition = resultDouble.1
                coordinate.Z = resultDouble.0
                currentPosition++;//comma
                coordinates.append(coordinate)
                let resultField = PeekFieldExists(data, currentPosition : currentPosition, toCheck : "coordinates")
                
                if (resultField.1 && resultField.2 == true)
                {
                    
                    currentPosition = resultField.0
                    break
                }
            }
        }
        else if (resultField.0.compare("Polygon") == NSComparisonResult(rawValue: 0) && resultField.1 == true)
        {
            break
        }
    }
    return (Polygon(extrude: extrude, altitudeMode: altitudeMode, coordinates: coordinates), currentPosition)
}*/

open class KMLReader
{
    init(){
        
    }
    func GetPlacemarks(_ data : String) -> [Placemark]
    {
        let asCArray : [Character] = data.characters.map { $0 }
        var result : [Placemark] = [Placemark]()
        var int = 0
        
        var currentPosition : Int = 0;
        while (currentPosition != data.characters.count)
        {
            let resultFolder = MatchPlaceMark(asCArray, currentPosition: currentPosition)
            result.append(resultFolder.0)
            //print (resultFolder.0.lookAt.tilt)
            currentPosition = resultFolder.1
            int += 1
            print(String(int) + "/n")
        }
        return result
    }
}

public func CompareCArray(_ cArray : [Character], cArray2 : [Character]) -> Bool
{
    let count : Int = cArray.count
    let count2 : Int = cArray2.count
    
    if (count != count2){
        return false;}
    for index in 0...count - 1
    {
        if (cArray[index] != cArray2[index])
        {
            return false;
        }
    }
    return true;
}

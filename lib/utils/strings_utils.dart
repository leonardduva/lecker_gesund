// Capitalize first character of a strings
String capitalizeFirst(String s) => s[0].toUpperCase() + s.substring(1);

String capitalizeFirstofEach(String s) =>
    s.split(" ").map((s) => capitalizeFirst(s)).join(" ");
//  Split by char
List split(String s) => s.split(',');

// trim white spaces begining and end
String trim(String s) => s.trim();

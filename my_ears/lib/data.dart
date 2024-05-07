class data{
List<String> date = ["March 06, 2024","March 07, 2024", "March 07, 2024","March 08, 2024"];
List<String> title = ["Discrete Time","HCI Lecture", "Machine Learning","Microprocessors"];
List<String> duration = ["2 hrs","3 hrs", "2 hrs","3 hrs"];
List<String> from =["8:00 AM", "8:00 AM","11:00 AM","8:00 AM"];
List<String> to =["10:00 AM","11:00 AM","1:00 PM","11:00 AM"];
List<String> months = ['January', 'February','March', 'April','May','June','July','August','September','October','November','December'];
int getDataLength(){
  return title.length;
}
String getDate(int i){
  return date[i];
}
String getTitle(int i){
  return title[i];
}
String getDuration(int i){
  return duration[i];
}
String getTo(int i){
  return to[i];
}
String getFrom(int i){
  return from[i];
}
void addDate(String newDate){date.add(newDate);}
void addTitle(String newTitle){title.add(newTitle);}
void addDuration(String newTitle){duration.add(newTitle);}
void addTo(String newTitle){to.add(newTitle);}
void addFrom(String newTitle){from.add(newTitle);}

int getTitlePos(String title){
  return title.indexOf(title);
}



}
class DashboardModel {
  final ProfileModel profile;
  final StatisticModel statistics;

  final List<ConfirmationModel> latestConfirmations;

  final ScheduleModel? nextSchedule;

  final MenuModel? todayMenu;

  final DistributionModel? todayDistribution;


  DashboardModel({
    required this.profile,
    required this.statistics,
    required this.latestConfirmations,
    this.nextSchedule,
    this.todayMenu,
    this.todayDistribution,
  });



  factory DashboardModel.fromJson(
      Map<String, dynamic> json) {

    return DashboardModel(

      profile: ProfileModel.fromJson(
        json['profile'] ?? {},
      ),


      statistics: StatisticModel.fromJson(
        json['statistics'] ?? {},
      ),


      latestConfirmations:
          ((json['latest_confirmations'] ?? [])
              as List)
              .map(
                (e) => ConfirmationModel.fromJson(
                  e,
                ),
              )
              .toList(),


      nextSchedule:
          json['next_schedule'] != null
              ? ScheduleModel.fromJson(
                  json['next_schedule'],
                )
              : null,


      todayMenu:
          json['today_menu'] != null
              ? MenuModel.fromJson(
                  json['today_menu'],
                )
              : null,


      todayDistribution:
          json['today_distribution'] != null
              ? DistributionModel.fromJson(
                  json['today_distribution'],
                )
              : null,

    );
  }
}





// ==================================================
// PROFILE
// ==================================================

class ProfileModel {

  String name;

  String? email;

  String? type;

  String? photo;



  ProfileModel({

    required this.name,

    this.email,

    this.type,

    this.photo,

  });



  factory ProfileModel.fromJson(
      Map<String,dynamic> json){

    return ProfileModel(

      name:
          json['name']
              ?.toString()
              ??
              '',


      email:
          json['email']
              ?.toString(),


      type:
          json['type']
              ?.toString()
              ??
              json['category']
              ?.toString(),


      photo:

          json['photo_url']
              ?.toString()
              ??
          json['photo']
              ?.toString(),

    );

  }

}







// ==================================================
// STATISTIC
// ==================================================

class StatisticModel {


  final int confirmationCount;


  final int? childAge;


  final int educationCount;




  StatisticModel({

    required this.confirmationCount,

    this.childAge,

    required this.educationCount,

  });





  factory StatisticModel.fromJson(
      Map<String,dynamic> json){


    return StatisticModel(


      confirmationCount:

          int.tryParse(
            json['confirmation_count']
                ?.toString()
                ??
                '0',
          )
          ??
          0,



      childAge:

          json['child_age'] != null

          ?

          int.tryParse(
            json['child_age']
                .toString(),
          )

          :

          null,



      educationCount:

          int.tryParse(
            json['education_count']
                ?.toString()
                ??
                '0',
          )
          ??
          0,


    );

  }

}







// ==================================================
// CONFIRMATION
// ==================================================

class ConfirmationModel {


  final int id;


  final String date;


  final String status;


  final int? rating;





  ConfirmationModel({

    required this.id,

    required this.date,

    required this.status,

    this.rating,

  });





  factory ConfirmationModel.fromJson(
      Map<String,dynamic> json){


    return ConfirmationModel(


      id:

          int.tryParse(
            json['id']
                ?.toString()
                ??
                '0',
          )
          ??
          0,



      date:

          json['received_at']
              ?.toString()
              ??
          json['date']
              ?.toString()
              ??
              '',



      status:

          json['status']
              ?.toString()
              ??
              '',



      rating:

          json['rating'] != null

          ?

          int.tryParse(
            json['rating']
                .toString(),
          )

          :

          null,


    );

  }

}








// ==================================================
// SCHEDULE
// ==================================================

class ScheduleModel {


  final int id;


  final String title;


  final String date;


  final String startTime;


  final String endTime;


  final String location;


  final String address;


  final String? image;





  ScheduleModel({

    required this.id,

    required this.title,

    required this.date,

    required this.startTime,

    required this.endTime,

    required this.location,

    required this.address,

    this.image,

  });





  factory ScheduleModel.fromJson(
      Map<String,dynamic> json){


    return ScheduleModel(


      id:

          int.tryParse(
            json['id']
                ?.toString()
                ??
                '0',
          )
          ??
          0,



      title:

          json['title']
              ?.toString()
              ??
              '',



      date:

          json['date']
              ?.toString()
              ??
              '',



      startTime:

          json['start_time']
              ?.toString()
              ??
              '',



      endTime:

          json['end_time']
              ?.toString()
              ??
              '',



      location:

          json['location']
              ?.toString()
              ??
              '',



      address:

          json['address']
              ?.toString()
              ??
              '',



      image:

          json['image_url']
              ?.toString()
              ??
          json['image']
              ?.toString(),

    );

  }

}









// ==================================================
// MENU MBG
// ==================================================

class MenuModel {


  final int id;


  final String title;


  final String description;


  final String? image;





  MenuModel({

    required this.id,

    required this.title,

    required this.description,

    this.image,

  });





  factory MenuModel.fromJson(
      Map<String,dynamic> json){


    return MenuModel(


      id:

          int.tryParse(
            json['id']
                ?.toString()
                ??
                '0',
          )
          ??
          0,



      title:

          json['title']
              ?.toString()
              ??
              '',



      description:

          json['description']
              ?.toString()
              ??
              '',



      image:

          json['image_url']
              ?.toString()
              ??
          json['image']
              ?.toString(),

    );

  }

}








// ==================================================
// DISTRIBUTION
// ==================================================

class DistributionModel {


  final String status;


  final int jumlahDikirim;


  final String? keterangan;




  DistributionModel({

    required this.status,

    required this.jumlahDikirim,

    this.keterangan,

  });





  factory DistributionModel.fromJson(
      Map<String,dynamic> json){


    return DistributionModel(


      status:

          json['status']
              ?.toString()
              ??
              '',



      jumlahDikirim:

          int.tryParse(
            json['jumlah_dikirim']
                ?.toString()
                ??
                '0',
          )
          ??
          0,



      keterangan:

          json['keterangan']
              ?.toString(),


    );

  }

}
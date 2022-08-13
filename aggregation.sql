# mongoimport persons.json  -d  lwperson -c persons --jsonArray

lwperson> db.persons.find({ "dob.age": 23  })

lwperson> db.persons.find({ "dob.age":   { $gt:  23 }   })

lwperson> db.persons.find({ "dob.age":  { $in:  [23,52,67]  }   })


lwperson> db.persons.find({ "dob.age":  { $nin:  [23,52,67]  }   })

lwperson> db.persons.find({ "dob.age":  { $gt: 40 }  ,   "registered.age": {  $lt: 2 }  })

lwperson> db.persons.find( { $and: [ { "dob.age":  { $gt: 40 }},  { "registered.age": {  $lt: 2 } } ]  } )


lwperson> db.persons.find( { $or: [ { "dob.age":  { $gt: 40 }},  { "registered.age": {  $lt: 2 } } ]  } )

lwperson> db.persons.aggregate([ { $match: { gender: 'male' } }])











analytics> db.persons.aggregate([ { $match: { gender: "female" } }])


db.persons.aggregate([ 
{ $match: { gender: "female" } },
{ $group: { _id: { state: "$location.state" }, totalPersons: { $sum: 1 }  } },
{ $sort: { totalPersons: -1 } }
])


db.persons.aggregate([ 
	{ $project: { _id: 0, gender: 1 } }
])

db.persons.aggregate([ 
	{ $project: { _id: 0, gender: 1, fullName: { $concat: ["Linux", " World" ] } } }
])

db.persons.aggregate([ 
	{ $project: { _id: 0, gender: 1, fullName: { $concat: ["$name.first", " ", "$name.last" ] } } }
])



db.persons.aggregate([ 
{ $project: { _id: 0, gender: 1, 
	fullName: { $concat: [{ $toUpper: "$name.first"} , " ", { $toUpper: "$name.last" } ] } } }
])



db.persons.aggregate([
    {
      $project: {
        _id: 0,
        gender: 1,
        fullName: {
          $concat: [
            { $toUpper: { $substrCP: ['$name.first', 0, 1] } },
            {
              $substrCP: [
                '$name.first',
                1,
                { $subtract: [{ $strLenCP: '$name.first' }, 1] }
              ]
            },
            ' ',
            { $toUpper: { $substrCP: ['$name.last', 0, 1] } },
            {
              $substrCP: [
                '$name.last',
                1,
                { $subtract: [{ $strLenCP: '$name.last' }, 1] }
              ]
            }
          ]
        }
      }
    }
  ]).pretty();



db.persons.aggregate([
    {
      $project: {
        _id: 0,
        name: 1,
        email: 1,
        birthdate: { $toDate: '$dob.date' },
        age: "$dob.age",
        location: {
          type: 'Point',
          coordinates: [
            {
              $convert: {
                input: '$location.coordinates.longitude',
                to: 'double',
                onError: 0.0,
                onNull: 0.0
              }
            },
            {
              $convert: {
                input: '$location.coordinates.latitude',
                to: 'double',
                onError: 0.0,
                onNull: 0.0
              }
            }
          ]
        }
      }
    },
    {
      $project: {
        gender: 1,
        email: 1,
        location: 1,
        birthdate: 1,
        age: 1,
        fullName: {
          $concat: [
            { $toUpper: { $substrCP: ['$name.first', 0, 1] } },
            {
              $substrCP: [
                '$name.first',
                1,
                { $subtract: [{ $strLenCP: '$name.first' }, 1] }
              ]
            },
            ' ',
            { $toUpper: { $substrCP: ['$name.last', 0, 1] } },
            {
              $substrCP: [
                '$name.last',
                1,
                { $subtract: [{ $strLenCP: '$name.last' }, 1] }
              ]
            }
          ]
        }
      }
    },
    { $group: { _id: { birthYear: { $isoWeekYear: "$birthdate" } }, numPersons: { $sum: 1 } } },
    { $sort: { numPersons: -1 } }
  ]).pretty();




db.persons.aggregate(
[
    { $match: { gender: 'male' } },

    { $project: { 
        _id: 0, 
        phone: 1, 
        email: 1, 
        "name.first": 1 , 
        "name.last": 1,
        "mycompanyname":  {  $concat:  [ "Linux" , " World" ] },
        "myname": "vimal daga"
        } 
    }

]
)






db.persons.aggregate(
[
    { $match: { gender: 'male' } },

    { $project:  { 
        phone: 1, 
        email:1, 
        name:1 , 
        _id: 0,
        birthday:  { $toDate:  "$dob.date" }
    }
},

    { $project: { 
        birthday: 1,
        tellmebirthyear:  {  $isoWeekYear:  "$birthday" },
        phone: 1, 
        email: 1, 
        "fullName": {  $concat:  
            [ 
               { $toUpper: "$name.title" }, 
                " " , 

               {  $toUpper: { $substrCP:  [ "$name.first" , 0 , 1 ] } } ,
               
               { $substrCP:  
                    [ 
                    "$name.first" , 
                    1 ,  
                    {  $subtract: 
                        [ 
                            { $strLenCP:  "$name.first" }, 
                            1 
                        ] 
                    }
                    ] 
                },

                " " ,
                "$name.last"  
                ] 
            }
        } 
    },

    { $group: 
        {
         _id: {  birthYear:  "$tellmebirthyear" } ,
         numPersons: { $sum: 1 } 
        }
    },

    {$sort:  {numPersons: -1 }}

]
)




db.persons.aggregate(

[
    { $match: { gender: 'male' } },

    { $group:  
        { 
            _id: { mystate: "$location.state" } ,
           totalMalePersons:  { $sum: 1 }
        }  
    },

    { $sort: { totalMalePersons: -1  } },

    { $out: { db: "outfinaldb", coll: "finalcol" } }
    
]

)





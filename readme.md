## Example

### DBFWriter
    dbfkit = require "dbfkit"
    DBFWriter = dbfkit.DBFWriter

    header = [
    {
      name: 'name',
      type: 'C'
    }, {
      name: 'gender',
      type: 'L'
    }, {
      name: 'birthday',
      type: 'D'
    }, {
      name: 'stature',
      type: 'N',
      precision: '2'
    }, {
      name: 'registDate',
      type: 'C'
    }
    ];

    doc = [
    {
      name: 'charmi',
      gender: true,
      birthday: new Date(),
      stature: 0,
      registDate: new Date()
    }, {
      name: '张三',
      gender: false,
      birthday: new Date(1935, 1, 2),
      stature: 1.87,
      registDate: new Date()
    }
    ];

    pathName = './dbfout';
    fileName = 'people.dbf';
    dbfWriter = new DBFWriter(header, doc, fileName, pathName, {
    encoding: 'gb2312',
    coverIfFileExist: true
    });
    dbfWriter.write();
    console.log("finish");

### DBFParser
    dbfkit = require "dbfkit"
    DBFParser = dbfkit.DBFParser
    
    pathName = './dbfout';
    fileName = 'people.dbf';
    dbfParser = new DBFParser(pathName + "/" + fileName, "GBK");

    dbfParser.on('head', function(head) {
    return console.log(head);
    });
    dbfParser.on('record', function(record) {
    return console.log(record);
    });
    dbfParser.on('end', function() {
    return console.log('finish');
    });

    dbfParser.parse();
    
### DBFQuery
    DBFQuery = require("dbfkit").DBFQuery;
    
    // KL_OBRAZ.DBF size: 15 Kb
    var selectObr = new DBFQuery('./KL_OBRAZ.DBF', null, null, 
							["NAIM","KOD"], null,
							function(records){
								console.log(records);
								console.log('ended... KL_OBRAZ');
							});
	
    // test1.dbf size: 357 Kb
    var selectPeaple = new DBFQuery('./test1.dbf', 
    						function(record){ return record['KART_N'] >= 3 && record['KART_N'] < 100},
    						['KOD_RM', 'FIO'],
    						['KART_N','IND_KART','KOD_RM','FIO','ROGD_DT', 'OBRAZ'],
    						'cp866',
    						function(records) {
    							console.log("===============================");
    							var count = DBFQuery.leftJoin(records, 'OBRAZ', selectObr.records, "KOD");
    							console.log(" Count joined:"+count);
    							console.log(records);
    							console.log('ended... test1');
                            });	 
    
    selectObr.selectSimple();
    selectPeaple.selectSimple();

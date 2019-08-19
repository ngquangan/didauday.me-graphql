import './configs/db/mongo';
import './configs/db/neo4j';

import { moveDataPerson } from './helpers/move-data-func';

import schedule from 'node-schedule';
 
schedule.scheduleJob('0 0 * * *', function(){
    moveDataPerson();
});
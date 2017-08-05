function array2time
  //this function gets an array of data and the time
  //it returns a time dependend stepwise result
  //each array value corresponds to a specific time interval
  input Real array[:];
  input Real time;
  output Real result;
protected
Integer array_length;
Real delta_time;
Real stop_time;
algorithm
stop_time:= 1;
array_length := size(array,1); //number of values
delta_time:=stop_time/(array_length-1); //size of time interval
for k in 1:array_length loop
  if time >delta_time*(k-1)-delta_time/2 and time <= delta_time*k-delta_time/2 then
   result:=array[k];
  end if;
end for;
  //if time >=stop_time-delta_time/2 then
  // result:=array[array_length-1];
  //end if;
end array2time; 

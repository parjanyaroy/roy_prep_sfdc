import { LightningElement, track } from 'lwc';

export default class TodoListApp extends LightningElement {

    taskValue = 'ABC';
    @track
    taskList = [
        {
        id : 1,
        name : 'task 1'
        },
        {
            id : 2,
            name : 'task 2'
        },
        {
            id : 3,
            name : 'task 3'
        }
            
    ];
    updateTaskVariable(event)
    {
        this.taskValue = event.target.value;
        console.log(this.taskValue);
    }
    addTask()
    {
        this.taskList.push({
            id : taskList.length +1 ,
            name : this.taskValue
        });
        console.log(taskList);
    }

}
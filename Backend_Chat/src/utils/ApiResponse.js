class ApiResponse{
    constructor(status, message, data){
        this.status = status;
        this.success = status >= 200 && status < 300 ? true : false;
        this.message = message;
        this.data = data;
    }
}
export {ApiResponse};
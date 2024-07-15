import axios from 'axios';
import { CustomResponse } from '../models/custom-response.model';
import { CommonUtils } from '../utils/common.utils';

export class DeployService {

    public async contractDeployment (req : any) : Promise<CustomResponse> {
        try {

            const {key, contract, definition, input} = req.body;
            const response = await axios.request(
                {
                    method: 'post',
                    url: `http://localhost:5000/api/v1/namespaces/default/contracts/deploy`,
                    data: {key, contract, definition, input},
                }
            )   
            const data =  response.data;
            return new CustomResponse(200, "Contract deployed successfully", null, data)
        } catch (error) {
            return CommonUtils.prepareErrorMessage(error);
        }
    }

    public async generateInterface (req : any)  {
        try {
            const abi = req.body;
            const response = await axios.request(
                {
                    method: 'post',
                    url: `http://localhost:5000/api/v1/namespaces/default/contracts/interfaces/generate`,
                    data: {input : abi},
                }
            )   
            const data =  response.data;
            return new CustomResponse(200, "Firefly interface generated successfully", null, data)

        } catch (error) {
            return CommonUtils.prepareErrorMessage(error);
        }
    }

    public async broadcastInterface(req : any) {
        try {
            const {namespace, name, version, description, methods, events} = req.body;
            const response = await axios.request(
                {
                    method: 'post',
                    url: `http://localhost:5000/api/v1/namespaces/default/contracts/interfaces`,
                    data: {namespace, name, version, description, methods, events},
                }
            )   
            const data =  response.data;
            return new CustomResponse(200, "Firefly interface broadcasted successfully", null, data)

        } catch (error) {
            return CommonUtils.prepareErrorMessage(error);
        }
    }

    public async createContractApis(req : any) {
        try {
            const {name, interfaceId} = req.body;
            const response = await axios.request(
                {
                    method: 'post',
                    url: `http://localhost:5000/api/v1/namespaces/default/apis`,
                    data: {name, interface : {id : interfaceId}},
                }
            )   
            const data =  response.data;
            return new CustomResponse(200, "urls fetched successfully", null, data)

        } catch (error) {
            return CommonUtils.prepareErrorMessage(error);
        }
    }

    public async invokeContract(req : any) {
        try {
            const {address, method, params} = req.body;
            const response = await axios.request(
                {
                    method: 'post',
                    url: `http://localhost:5000/api/v1/namespaces/default/contracts/invoke`,
                    data: {location : {address}, method : {name : method , params}},
                }
            )   
            const data =  response.data;
            return new CustomResponse(200, "urls fetched successfully", null, data)

        } catch (error) {
            return CommonUtils.prepareErrorMessage(error);
        }
    }
}

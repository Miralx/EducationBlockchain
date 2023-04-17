pragma solidity ^0.4.0;

contract ClassManage {
    struct Class {
        uint256 id;
        string name;
        string uploader;
        string website;
        string uploadTime;
    }
    uint256 length = classes.length;
    Class[] classes;

    function getLength() public view returns (uint256) {
        return classes.length;
    }

    function getClass(uint256 i)
        public
        view
        returns (
            uint256,
            string,
            string,
            string,
            string
        )
    {
        return (
            classes[i].id,
            classes[i].name,
            classes[i].uploader,
            classes[i].website,
            classes[i].uploadTime
        );
    }

    function getClassById(uint256 id)
        public
        view 
        returns (
            uint256,
            string,
            string,
            string,
            string
        )
    {
        uint256 i;
        for (i = 0; i < classes.length; i++) {
            if (classes[i].id == id) break;
        }
        return (
            classes[i].id,
            classes[i].name,
            classes[i].uploader,
            classes[i].website,
            classes[i].uploadTime
        );
    }

    function insertClass(
        string name,
        string uploader,
        string website,
        string uploadeTime
    ) public returns (string) {
        classes.push(Class(length, name, uploader, website, uploadeTime));
        length++;
        return "Insert succeeded!";
    }

    function updateClass(
        uint256 id,
        string name,
        string uploader,
        string website,
        string uploadTime
    ) public returns (string) {
        uint256 index;
        for (index = 0; index < classes.length; index++) {
            if (classes[index].id == id) break;
        }
        if (index == classes.length) return "Cannot find student";
        else {
            classes[index].name = name;
            classes[index].uploader = uploader;
            classes[index].website = website;
            classes[index].uploadTime = uploadTime;
            return "Update succeeded!";
        }
    }

    function deleteClass(uint256 id) public returns (string) {
        uint256 index;
        for (index = 0; index < classes.length; index++) {
            if (classes[index].id == id) break;
        }
        if (index == classes.length) return "Cannot find student";
        else {
            uint256 len = classes.length;
            for (uint256 i = index; i < len - 1; i++) {
                classes[i] = classes[i + 1];
            }
            delete classes[len - 1];
            classes.length--;
        }
    }
}

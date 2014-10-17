(function () {
    //队列单元格式
    //node = {'isready':false,'fn':undefined,'arguments':[]};
    var N = function(){
        this.isready = false;
        this.fn = null;
        this.arguments = null;
    };
    N.prototype.setFn = function(_fn){

        if(!_fn || !_fn.constructor===Function){
            return;
        }
        this.fn = _fn;
    };
    N.prototype.does = function(){

        var o = this;
        if(o.arguments){
            o.fn.apply(o.fn, o.arguments);
        }else{
            o.fn();
        }
    };
    N.prototype.ready = function(){
        this.isready = true;
    };
    //函数队列1.函数传入2.顺序执行3.条件满足(或触发)时执行4.异步5.函数执行时回调6.队列完成时回调
    var Z = function (_name) {
        this.name = _name || 'zombies';
        //总的队列 对象
        this.mapQueue = {};
        //为准备好的 数组
        this.queue = [];
        //已经满足条件的待执行(就绪ready) 数组
        this.excuteQueue = [];
        //ascii码中，a == 97
        this.codeLength = 97;

    };
    //函数执行的最少间隔(毫秒)
    Z.prototype.excuteDelay = function(_t){
        this.delayed = _t;
    };
    //同步执行ready队列内的函数
    Z.prototype.excute = function(){

        var o = this;
        if(o.delayed){

            var i = this.excuteQueue.length;
            while(i>0){

                setTimeout( function(){
                    o.excuteQueue.shift().does();
                }, (2-i)*o.delayed);

                i--;
            }
        }else{
            while(this.excuteQueue.length){
                this.excuteQueue.shift().does();
            }
        }
    };
    //1.触发并将该节点设置为ready。传入参数，如果有。
    //2.放入ready队列，如果该节点的顺位是满足情况的(即在总队列的头部)，否则不作为。
    Z.prototype.trigger = function(_evt,_arg){

        var node = this.mapQueue[_evt];

        if(!node){
            throw new Error('no that trigger');
            return;
        }else{
            node.ready();
        }
        if(_evt && (_arg || _arg===0) ){
            node.arguments = [];
            for(var i=1;i<arguments.length;i++){
                node.arguments[i-1] = arguments[i];
            }
        }
        var i = this.queue.indexOf(node);
        if(i==0){

            this.excuteQueue.push(this.queue.shift());

            while(this.queue.length){

                var n = this.queue[0];
                if(n.isready){
                    this.excuteQueue.push(this.queue.shift());
                }else{
                    break;
                }
            }
            this.excute();
        }
    };
    //插入，{ 此处应该返回一个触发器，
    Z.prototype.push = function(_fn,_arg,_evt){

        var node = new N();
        node.setFn(_fn,_arg);

        if(_evt){

            if(this.mapQueue[_evt]){
                throw new Error('key is existed');
                return;
            }
            this.mapQueue[_evt] = node;
            this.queue.push(node);
            node.name = _evt;

            return _evt;
        }else{

            var k = String.fromCharCode(this.codeLength++);

            this.mapQueue[k] = node;
            this.queue.push(node);
            node.name = k;

            return k;
        }
    };

    module.exports = Z;
}());
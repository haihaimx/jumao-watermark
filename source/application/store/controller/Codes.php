<?php

namespace app\store\controller;

use app\store\model\CodesRecord as CodesRecordModel;
use app\store\model\Codes as CodesModel;

/**
 * 卡密管理
 * Class User
 * @package app\store\controller
 */
class Codes extends Controller
{
    /**
     * 表格标题
     * @var array
     */
    private $tileArray = [
        'ID', '卡密', '有效天数', '充值用户', '状态', '创建时间'
    ];

    /**
     * 卡密列表
     * @param string $nickName
     * @param null $gender
     * @return mixed
     * @throws \think\exception\DbException
     */
    public function index($nickName = '', $gender = null)
    {
        $model = new CodesModel;
        $list = $model->getList($nickName, $gender);
        return $this->fetch('index', compact('list'));
    }

    /**
     * 卡密使用记录
     */
    public function lists()
    {
        $model = new CodesRecordModel();
        $list = $model->getList();
        return $this->fetch('record', compact('list'));
    }


    /**
     * 卡密导出
     */
    public function export()
    {

        $list = (new CodesModel())->order(['codes_id' => 'desc'])->select()->toArray();

        // 表格内容
        $dataArray = [];
        foreach ($list as $item) {
            $dataArray[] = [
                'ID' => $this->filterValue($item['codes_id']),
                '卡密' => $this->filterValue($item['codes']),
                '有效天数' => $this->filterValue($item['days']),
                '充值用户' => $this->filterValue($item['user_id']),
                '状态' => $this->filterValue($item['is_use'] == 1 ? '已使用' : '未使用'),
                '创建时间' => $this->filterValue($item['create_time']),
            ];
        }
        // 导出csv文件
        $filename = 'KaMi-' . date('YmdHis');
        return export_excel($filename . '.csv', $this->tileArray, $dataArray);
    }

    /**
     * 表格值过滤
     * @param $value
     * @return string
     */
    private function filterValue($value)
    {
        return "\t" . $value . "\t";
    }

    /**
     * 日期值过滤
     * @param $value
     * @return string
     */
    private function filterTime($value)
    {
        if (!$value) return '';
        return $this->filterValue(date('Y-m-d H:i:s', $value));
    }

    /**
     * 添加角色
     * @return array|mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \Exception
     */
    public function add()
    {
        $model = new CodesModel();
        if (!$this->request->isAjax()) {
            return $this->fetch('add');
        }
        // 新增记录
        if ($model->add($this->postData('codes'))) {
            return $this->renderSuccess('添加成功', url('codes/index'));
        }
        return $this->renderError($model->getError() ?: '添加失败');
    }


    /**
     * 用户充值
     * @param $user_id
     * @param int $source 充值类型
     * @return array|bool
     * @throws \think\Exception
     * @throws \think\exception\DbException
     */
    public function recharge($user_id, $source)
    {
        // 用户详情
        $model = CodesModel::detail($user_id);
        if ($model->recharge($this->store['user']['user_name'], $source, $this->postData('recharge'))) {
            return $this->renderSuccess('操作成功');
        }
        return $this->renderError($model->getError() ?: '操作失败');
    }

    /**
     * 删除用户
     * @param $user_id
     * @return array
     * @throws \think\exception\DbException
     */
    public function delete($codes_id)
    {
        // 商品详情
        $model = CodesModel::detail($codes_id);
        if (!$model->setDelete()) {
            return $this->renderError('删除失败');
        }
        return $this->renderSuccess('删除成功');
    }

    /**
     * 批量删除未使用
     * @param $user_id
     * @return array
     * @throws \think\exception\DbException
     */
    public function delete1()
    {
        (new CodesModel)->where('is_use', 0)->delete();
        return $this->renderSuccess('删除成功');
    }

    /**
     * 批量删除已使用
     * @param $user_id
     * @return array
     * @throws \think\exception\DbException
     */
    public function delete2()
    {
        (new CodesModel)->where('is_use', 1)->delete();
        return $this->renderSuccess('删除成功');

    }

    /**
     * 删除用户
     * @param $user_id
     * @return array
     * @throws \think\exception\DbException
     */
    public function deleteRecord()
    {
        $model = new CodesRecordModel();
        if (!$model->where("wxapp_id", $this->getWxappId())->delete()) {
            return $this->renderError('删除失败');
        }
        return $this->renderSuccess('删除成功');
    }

}

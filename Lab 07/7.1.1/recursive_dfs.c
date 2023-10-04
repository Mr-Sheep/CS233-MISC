int recursive_dfs(int target, int i, int *tree)
{
    if (i <= 0 || i >= 127)
    {
        return -1;
    }
    if (target == tree[i])
    {
        return 0;
    }

    int ret = recursive_dfs(target, 2 * i, tree);
    if (ret >= 0)
    {
        return ret + 1;
    }
    ret = recursive_dfs(target, 2 * i + 1, tree);
    if (ret >= 0)
    {
        return ret + 1;
    }
    return ret;
}

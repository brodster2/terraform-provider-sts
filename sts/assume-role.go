package sts

import (
	"context"
	"strconv"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/credentials/stscreds"
	"github.com/aws/aws-sdk-go-v2/service/sts"

	"github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
)

func dataSourceAssumeRole() *schema.Resource {
	return &schema.Resource{
		ReadContext: dataSourceAssumeRoleRead,
		Schema: map[string]*schema.Schema{
			"role_arn": {
				Type:     schema.TypeString,
				Required: true,
			},
			"access_key_id": {
				Type:     schema.TypeString,
				Computed: true,
			},
			"secret_access_key": {
				Type:     schema.TypeString,
				Computed: true,
			},
			"session_token": {
				Type:     schema.TypeString,
				Computed: true,
			},
		},
	}
}

func dataSourceAssumeRoleRead(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	var diags diag.Diagnostics

	role_arn := d.Get("role_arn").(string)

	config := m.(aws.Config)

	stsSvc := sts.NewFromConfig(config)
	provider := stscreds.NewAssumeRoleProvider(stsSvc, role_arn)

	creds, err := provider.Retrieve(ctx)
	if err != nil {
		return diag.FromErr(err)
	}

	err = d.Set("access_key_id", creds.AccessKeyID)
	if err != nil {
		return diag.FromErr(err)
	}
	err = d.Set("secret_access_key", creds.SecretAccessKey)
	if err != nil {
		return diag.FromErr(err)
	}
	err = d.Set("session_token", creds.SessionToken)
	if err != nil {
		return diag.FromErr(err)
	}

	// always run
	d.SetId(strconv.FormatInt(time.Now().Unix(), 10))

	return diags

}

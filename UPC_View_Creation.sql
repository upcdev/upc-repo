migrationBuilder.Sql(@"CREATE VIEW [dbo].[vBusiness] AS
                          SELECT [BusinessId]
                              ,b.[BusinessTypeId]
                              ,bt.[BusinessTypeName]
                              ,b.[AssociationId]
                              ,a.[AssociationName]
                              ,[BusinessName]
                              ,[PaintRatio]
                              ,[BusinessOverheads]
                              ,[BusinessHrs]
                              ,[Location]
                              ,[BusinessDescription]
                              ,[CreatedDate]
                          FROM [dbo].[Business] AS b
                          INNER JOIN [dbo].[BusinessType] AS bt
                          ON b.[BusinessTypeId] = bt.Id
                          INNER JOIN [dbo].[Association] AS a
                          ON b.[AssociationId] = a.Id");

            migrationBuilder.Sql(@"CREATE VIEW [dbo].[vEmployee] AS   
                          SELECT e.[Id]
                              ,[BusinessId]
                              ,[PositionId]
                              ,[PositionName]
                              ,PositionTypeId
                              ,[PositionTypeName]
                              ,[StartDate]
                              ,[EndDate]
                              ,[EmployeeName]
                              ,[Salary]
                          FROM[dbo].[Employee] AS e
                          INNER JOIN[Position] AS p
                          ON e.[PositionId] = p.Id
                          INNER JOIN[PositionType] AS pt
                          ON pt.[Id] = p.PositionTypeId");

            migrationBuilder.Sql(@"CREATE VIEW [dbo].[vPosition] AS           
                                  SELECT p.[Id]                                   AS[PositionId]
                                      ,[PositionTypeId]
                                      ,[PositionName]
                                      ,[PositionTypeName]        
                                  FROM[dbo].[PositionType] AS pt        
                                  INNER JOIN[dbo].[Position] AS p        
                                  ON pt.[Id] = p.[PositionTypeId]");


            migrationBuilder.Sql(@"CREATE VIEW [dbo].[vWorkProvider] AS                            
                          SELECT wp.[Id]
                              ,[WorkProviderId]
                          	  ,wpl.WorkProviderName
                              ,[WarrantyStatusId]
                          	  ,ws.WarrantyStatusName
                              ,wp.[BusinessId]
                          	  ,[BusinessName]
                              ,[RepairTypeId]
                          	  ,rt.RepairTypeName
                              ,[StartDate]
                              ,[EndDate]
                              ,[LabourVolume]
                              ,[PaintLabourVolume]
                              ,[LabourRateAmt]
                              ,[PaintLabourRateAmt]
                          FROM [dbo].[WorkProviderDetails] AS wp
                          LEFT JOIN dbo.Business AS b
                          ON wp.[BusinessId] = b.[BusinessId]
                          LEFT JOIN dbo.WorkProviderList AS wpl
                          ON wp.[WorkProviderId] = wpl.Id
                          LEFT JOIN dbo.WarrantyStatus AS ws
                          ON wp.[WarrantyStatusId] = ws.Id
                          LEFT JOIN dbo.RepairType AS rt
                          ON wp.[RepairTypeId] = rt.Id");

            migrationBuilder.Sql(@"CREATE VIEW [dbo].[vWorkProviderWAC] AS     
                           SELECT CAST(ROW_NUMBER() OVER( ORDER BY [WorkProviderId]) AS INT)									AS Id
                               ,[WorkProviderId]
                               ,wpl.[WorkProviderName]
                               ,[WarrantyStatusId]
                               ,ws.[WarrantyStatusName]
                               ,[BusinessId]
                               ,[RepairTypeId]
                               ,rt.[RepairTypeName]
                               ,SUM([LabourVolume])																				AS [LabourVolume]
                               ,SUM([PaintLabourVolume])																		AS [PaintLabourVolume]
                               ,CAST(SUM([LabourRateAmt] * [LabourVolume])/SUM([LabourVolume]) AS DECIMAL(6,2))					AS [LabourRateAmt]
                               ,CAST(SUM([PaintLabourRateAmt] * [PaintLabourVolume])/SUM([PaintLabourVolume]) AS DECIMAL(6,2))	AS PaintLabourRateAmt		
                           FROM [dbo].[WorkProviderDetails] AS wp
                           INNER JOIN [dbo].[RepairType] AS rt
                           ON wp.[RepairTypeId] = rt.Id
                           INNER JOIN [dbo].[WarrantyStatus] AS ws
                           ON wp.[WarrantyStatusId] = ws.Id
                           INNER JOIN [dbo].[WorkProviderList] as wpl
                           ON wp.[WorkProviderId] = wpl.Id
                           WHERE GETDATE() BETWEEN [StartDate] AND [EndDate]
                           GROUP BY [WorkProviderId]
                              ,wpl.[WorkProviderName]
                              ,[WarrantyStatusId]
                              ,ws.[WarrantyStatusName]
                              ,[BusinessId]
                              ,[RepairTypeId]
                              ,rt.[RepairTypeName]");